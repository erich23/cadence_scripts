import BnGNFT from 0xProfile //todo
import NonFungibleToken from 0xProfile

// This transaction transfers an NFT from one user's collection
// to another user's collection.
transaction (senderAddress: Address, receiverAddress: Address, id: UInt64){

    // The field that will hold the NFT as it is being
    // transferred to the other account
    let senderCollectionRef: &BnGNFT.Collection
    // Admin account authorizer ONLY
    prepare(acct: AuthAccount) {
        // Borrow a capability for the NFTMinter in storage
        self.senderCollectionRef = acct.borrow<&BnGNFT.Collection>(from: BnGNFT.CollectionStoragePath)
            ?? panic("Could not borrow sender's collection reference")
    }

    execute {
        // Get the recipient's public account object
        let recipient = getAccount(receiverAddress)

        // Get the Collection reference for the receiver
        // getting the public capability and borrowing a reference from it
        let receiverRef = recipient.getCapability<&{BnGNFT.BnGNFTCollectionPublic}>(BnGNFT.CollectionPublicPath)
            .borrow()
            ?? panic("Could not borrow receiver reference")

        // Use the minter reference to mint an NFT, which deposits
        // the NFT into the collection that is sent as a parameter.
        let newNFT <- self.senderCollectionRef.withdraw(withdrawID: id)

        // Deposit the NFT in the receivers collection
        receiverRef.deposit(token: <-newNFT)
    }
}