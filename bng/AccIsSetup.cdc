import BnGNFTContract from 0xProfile

pub fun main(targetAddress: Address) : [{String : String}] {
    let nftOwner = getAccount(targetAddress)

    let capability = nftOwner.getCapability<&{BnGNFTContract.NFTReceiver}>(/public/NFTReceiver)

    let receiverRef = capability.borrow()
        ?? return "Account is not setup"
    return "Account is setup"
}