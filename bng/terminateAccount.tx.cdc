import BnGNFTContract from 0xProfile //todo

// This transaction terminates a user's account and burns 
// all bng-related resources under /storage/BnGNFTCollection
transaction {
    prepare(acct: AuthAccount) {

    //unlink NFTReceiver capability 
    acct.unlink(/public/NFTReceiver)

    // destroy collection in storage
    let collection <- acct.load<@BnGNFTContract.Collection>(from: /storage/BnGNFTCollection)
    
    destroy collection
    }
}