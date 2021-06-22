import BnGNFTContract from 0xProfile

transaction (id:UInt64) {
    collectionRef : &BnGNFTContract.BnGNFTCollection
    prepare(acct: AuthAccount) {
        // Create a new empty collection
        self.collectionRef = acctAdmin.borrow<&BnGNFTContract.BnGNFTCollection>(from: /storage/BnGNFTCollection)
    }
    execute {
        let token <-self.collectionRef.ownedNFTs.remove(key: id)!
        destroy token
    }
}