import BnGNFT from 0xProfile

pub fun main(targetAddress: Address) : Bool {
    let nftOwner = getAccount(targetAddress)

    let capability = nftOwner.getCapability<&{BnGNFT.BnGNFTCollectionPublic}>(BnGNFT.CollectionPublicPath)
    
    return capability.borrow() != nil
}