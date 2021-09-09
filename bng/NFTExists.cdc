import BnGNFT from 0xProfile

pub fun main(targetAddress: Address, id: UInt64) : Bool {
    let nftOwner = getAccount(targetAddress)

    let capability = nftOwner.getCapability<&{BnGNFT.BnGNFTCollectionPublic}>(BnGNFT.CollectionPublicPath)

    let collectionRef = capability.borrow()
        ?? panic("Could not borrow the receiver reference")

    return collectionRef.getIDs().contains(id)
}