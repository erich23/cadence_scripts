import NonFungibleToken from "./NonFungibleToken.cdc"
// BnGNFT.cdc
//
// This is a complete version of the ExampleNFT contract
// that includes withdraw and deposit functionality, as well as a
// collection resource that can be used to bundle NFTs together.
//
// It also includes a definition for the Minter resource,
// which can be used by admins to mint new NFTs.
//
// Learn more about non-fungible tokens in this tutorial: https://docs.onflow.org/docs/non-fungible-tokens

pub contract BnGNFT : NonFungibleToken {


    // Declare the NFT resource type
    pub resource NFT : NonFungibleToken.INFT {
        // The unique ID that differentiates each NFT
        pub let id: UInt64
        // Initialize the field in the init function
        init(initID: UInt64) {
            self.id = initID
        }
    }

    // We define this interface purely as a way to allow users
    // to create public, restricted references to their NFT Collection.
    // They would use this to only expose the deposit, getIDs,
    // and idExists fields in their Collection
    pub resource interface BnGNFTCollectionPublic {

        pub fun deposit(token: @NonFungibleToken.NFT)

        pub fun getIDs(): [UInt64]

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT

        pub fun borrowBnGNFT(id: UInt64): &BnGNFT.NFT? {
            // If the result isn't nil, the id of the returned reference
            // should be the same as the argument to the function
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow BnGNFT reference: The ID of the returned reference is incorrect"
            }
        }
    }

    // The definition of the Collection resource that
    // holds the NFTs that a user owns
    pub resource Collection: BnGNFTCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        // Initialize the NFTs field to an empty collection
        init () {
            self.ownedNFTs <- {}
        }

        // withdraw 
        //
        // Function that removes an NFT from the collection 
        // and moves it to the calling context
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            // If the NFT isn't found, the transaction panics and reverts
            let token <- self.ownedNFTs.remove(key: withdrawID)!
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <-token
        }

        // deposit 
        pub fun deposit(token: @NonFungibleToken.NFT) {
            // add the new token to the dictionary with a force assignment
            // if there is already a value at that key, it will fail and revert
            let token <- token as! @BnGNFT.NFT
            let id: UInt64 = token.id
            self.ownedNFTs[id] <-! token
            emit Deposit(id: id, to: self.owner?.address)
        }

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // borrowNFT
        // Gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        //
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        // borrowKittyItem
        // Gets a reference to an NFT in the collection as a KittyItem,
        // exposing all of its fields (including the typeID).
        // This is safe as there are no functions that can be called on the KittyItem.
        //
        pub fun borrowBnGNFT(id: UInt64): &BnGNFT.NFT? {
            if self.ownedNFTs[id] != nil {
                let ref = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
                return ref as! &BnGNFT.NFT
            } else {
                return nil
            }
        }


        destroy() {
            destroy self.ownedNFTs
        }
    }

    // creates a new empty Collection resource and returns it 
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    // NFTMinter
    //
    // Resource that would be owned by an admin or by a smart contract 
    // that allows them to mint new NFTs when needed
    pub resource NFTMinter {

        // the ID that is used to mint NFTs
        // it is only incremented so that NFT ids remain
        // unique. It also keeps track of the total number of NFTs
        // in existence
        pub var idCount: UInt64

        init() {
            self.idCount = 1
        }

        // mintNFT 
        //
        // Function that mints a new NFT with a new ID
        // and returns it to the caller
        pub fun mintNFT(): @BnGNFT.NFT {

            // create a new NFT
            var newNFT <- create BnGNFT.NFT(initID: BnGNFT.totalSupply)
            BnGNFT.totalSupply = BnGNFT.totalSupply + 1 as UInt64
            
            return <-newNFT
        }
    }

    pub var totalSupply: UInt64

    //events
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    

    // Named Paths
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let MinterStoragePath: StoragePath

	init() {

        self.CollectionStoragePath = /storage/BnGNFTCollection
        self.CollectionPublicPath = /public/BnGNFTCollection
        self.MinterStoragePath = /storage/NFTMinter

        self.totalSupply = 0

        // store a minter resource in account storage
        self.account.save(<-create NFTMinter(), to: self.MinterStoragePath)

        emit ContractInitialized()
	}
}
 
