import ExampleToken from 0xb6fba1379cc97f72

transaction {
    prepare(signer: auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue) &Account) {
        // Create empty vault
        let vaultA <- ExampleToken.createEmptyVault()

        // Save vault
        signer.storage.save(<-vaultA, to: ExampleToken.VaultStoragePath)

        // Create capability
        let receiverCap = signer.capabilities.storage.issue<&ExampleToken.Vault>(
            ExampleToken.VaultStoragePath
        )

        // Publish capability
        signer.capabilities.publish(receiverCap, at: ExampleToken.VaultPublicPath)
    }
} 