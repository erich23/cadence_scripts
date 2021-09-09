import BnGNFT from 0xProfile

pub fun main(targetAddress: Address) : [{String : String}] {
    let nftOwner = getAccount(targetAddress)

    let capability = nftOwner.getCapability<&{BnGNFT.BnGNFTCollectionPublic}>(BnGNFT.CollectionPublicPath)

    let collectionRef = capability.borrow()
        ?? panic("Could not borrow the collection reference")
        
    let IDs = collectionRef.getIDs()
    
    var metadata : [{String:String}] = []
    for id in IDs {
        // metadata[id] = receiverRef.getMetadataByID(id: id)
        var bngNFTRef : &BnGNFT.NFT = collectionRef.borrowBnGNFT(id: id) ?? panic("couldnt find NFT reference")
        metadata = metadata.concat([bngNFTRef.getMetadata()])
    }
    return metadata
}