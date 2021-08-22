import BnGNFTContract from 0xProfile

pub fun main(targetAddress: Address) : Bool {
    let nftOwner = getAccount(targetAddress)

    let capability = nftOwner.getCapability<&{BnGNFTContract.NFTReceiver}>(/public/NFTReceiver)

    let receiverRef = capability.borrow()
    if receiverRef == nil {
        return false
    }
    return true
}