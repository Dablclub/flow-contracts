import BasicNFT from 0x YOUR_CONTRACT_ADDRESS

transaction {
    prepare(
        signer1: auth(LoadValue) &Account,
        signer2: auth(SaveValue, IssueStorageCapabilityController, PublishCapability) &Account
    ) {
        // Check if recipient already has an NFT
        if signer2.storage.borrow<&BasicNFT.NFT>(from: /storage/BasicNFTPath) != nil {
            panic("Recipient already has a token!")
        }

        // Load NFT from sender
        let nft <- signer1.storage.load<@BasicNFT.NFT>(from: /storage/BasicNFTPath)
            ?? panic("Could not load NFT from sender's storage")

        // Save NFT to recipient
        signer2.storage.save(<-nft, to: /storage/BasicNFTPath)

        // Create and publish capability for recipient
        let capability = signer2.capabilities.storage
            .issue<&BasicNFT.NFT>(/storage/BasicNFTPath)

        signer2.capabilities.publish(
            capability, 
            at: /public/BasicNFTPath
        )
    }
} 