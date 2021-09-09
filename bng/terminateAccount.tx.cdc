import BnGNFT from 0xProfile //todo
import NonFungibleToken from 0xProfile//todo

// This transaction terminates a user's account and burns 
// all bng-related resources under /storage/BnGNFTCollection
transaction {
    prepare(acct: AuthAccount) {

    //unlink NFTReceiver capability 
    acct.unlink(BnGNFT.CollectionPublicPath)

    // destroy collection in storage
    let collection <- acct.load<@NonFungibleToken.Collection>(from: BnGNFT.CollectionStoragePath)
    
    destroy collection
    }
}