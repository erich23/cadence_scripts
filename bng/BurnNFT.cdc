import BnGNFT from 0xProfile

transaction (id:UInt64) {
    prepare(acctAdmin: AuthAccount) {
        // Create a new empty collection
        let collectionRef : &BnGNFT.Collection = acctAdmin.borrow<&BnGNFT.Collection>(from: BnGNFT.CollectionStoragePath) ?? panic("Couldn't get collection reference")
        let token <- collectionRef.ownedNFTs.remove(key: id)!
        destroy token
    }
    execute {
    }
}