import BnGNFTContract from 0xProfile

pub fun main(targetAddress: Address, id: UInt64) : Bool {
    let nftOwner = getAccount(targetAddress)

    let capability = nftOwner.getCapability<&{BnGNFTContract.NFTReceiver}>(/public/NFTReceiver)

    let receiverRef = capability.borrow()
        ?? panic("Could not borrow the receiver reference")

    return receiverRef.idExists(id: id);
}