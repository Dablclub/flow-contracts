import BasicNFT from 0xb6fba1379cc97f72

access(all) fun main(address: Address): UInt64 {
    let account = getAccount(address)

    let nftReference = account.capabilities
        .borrow<&BasicNFT.NFT>(/public/BasicNFTPath)
        ?? panic("Could not borrow a reference")

    return nftReference.id
} 