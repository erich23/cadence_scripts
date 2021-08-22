import BnGNFTContract from 0xProfile //todo

// This transaction configures a user's account
// to use the NFT contract by creating a new empty collection,
// storing it in their account storage, and publishing a capability
transaction {
  prepare(acct: AuthAccount) {

    // Create a new empty collection
    let collection <- BnGNFTContract.createEmptyCollection()

    // store the empty NFT Collection in account storage
    acct.save<@BnGNFTContract.Collection>(<-collection, to: /storage/BnGNFTCollection)

    // create a public capability for the Collection
    acct.link<&{BnGNFTContract.NFTReceiver}>(/public/NFTReceiver, target: /storage/BnGNFTCollection)
  }
}