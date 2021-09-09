import BnGNFT from 0xProfile //todo
import NonFungibleToken from 0xProfile
// This transaction configures a user's account
// to use the NFT contract by creating a new empty collection,
// storing it in their account storage, and publishing a capability
transaction {
  prepare(acct: AuthAccount) {

    // Create a new empty collection
    let collection <- BnGNFT.createEmptyCollection()

    // store the empty NFT Collection in account storage
    acct.save<@NonFungibleToken.Collection>(<-collection, to: BnGNFT.CollectionStoragePath)

    // create a public capability for the Collection
    acct.link<&{BnGNFT.BnGNFTCollectionPublic}>(BnGNFT.CollectionPublicPath, target: BnGNFT.CollectionStoragePath)
  }
}