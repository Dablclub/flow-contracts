import BasicNFT from 0xb6fba1379cc97f72

transaction {
    prepare(acct: auth(BorrowValue, SaveValue, IssueStorageCapabilityController, PublishCapability) &Account) {
        // Check if user already has an NFT
        if acct.storage.borrow<&BasicNFT.NFT>(from: /storage/BasicNFTPath) != nil {
            panic("This user has a token already!")
        }

        // Mint and save the NFT
        acct.storage.save(
            <-BasicNFT.mintNFT(description: "Hi there!"), 
            to: /storage/BasicNFTPath
        )

        // Create and publish capability
        let capability = acct.capabilities.storage
            .issue<&BasicNFT.NFT>(/storage/BasicNFTPath)

        acct.capabilities.publish(
            capability, 
            at: /public/BasicNFTPath
        )
    }
} 