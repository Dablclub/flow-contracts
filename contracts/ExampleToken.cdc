access(all) contract ExampleToken {

    access(all) entitlement Withdraw

    // Storage Paths
    access(all) let VaultStoragePath: StoragePath
    access(all) let VaultPublicPath: PublicPath

    // Total Supply
    access(all) var totalSupply: UFix64

    // Balance Interface
    access(all) resource interface Balance {
        access(all) var balance: UFix64
    }

    // Provider Interface
    access(all) resource interface Provider {
        access(Withdraw) fun withdraw(amount: UFix64): @Vault {
            post {
                result.balance == amount:
                    "ExampleToken.Provider.withdraw: Cannot withdraw tokens!"
                    .concat("The balance of the withdrawn tokens (").concat(result.balance.toString())
                    .concat(") is not equal to the amount requested to be withdrawn (")
                    .concat(amount.toString()).concat(")")
            }
        }
    }

    // Receiver Interface
    access(all) resource interface Receiver {
        access(all) fun deposit(from: @Vault)
    }

    // Vault Resource
    access(all) resource Vault: Balance, Provider, Receiver {
        access(all) var balance: UFix64

        init(balance: UFix64) {
            self.balance = balance
        }

        access(Withdraw) fun withdraw(amount: UFix64): @Vault {
            pre {
                self.balance >= amount:
                    "ExampleToken.Vault.withdraw: Cannot withdraw tokens! "
                    .concat("The amount requested to be withdrawn (").concat(amount.toString())
                    .concat(") is greater than the balance of the Vault (")
                    .concat(self.balance.toString()).concat(")")
            }
            self.balance = self.balance - amount
            return <-create Vault(balance: amount)
        }

        access(all) fun deposit(from: @Vault) {
            self.balance = self.balance + from.balance
            destroy from
        }
    }

    // Create Empty Vault
    access(all) fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    // Minter Resource
    access(all) resource VaultMinter {
        access(all) fun mintTokens(amount: UFix64, recipient: Capability<&{Receiver}>) {
            let recipientRef = recipient.borrow()
                ?? panic(ExampleToken.vaultNotConfiguredError(address: recipient.address))

            ExampleToken.totalSupply = ExampleToken.totalSupply + UFix64(amount)
            recipientRef.deposit(from: <-create Vault(balance: amount))
        }
    }

    // Error Helper
    access(all) fun vaultNotConfiguredError(address: Address): String {
        return "Could not borrow a collection reference to recipient's ExampleToken.Vault"
            .concat(" from the path ")
            .concat(ExampleToken.VaultPublicPath.toString())
            .concat(". Make sure account ")
            .concat(address.toString())
            .concat(" has set up its account ")
            .concat("with an ExampleToken Vault.")
    }

    init() {
        self.VaultStoragePath = /storage/CadenceFungibleTokenTutorialVault
        self.VaultPublicPath = /public/CadenceFungibleTokenTutorialReceiver

        self.totalSupply = 30.0

        // Create and save minter
        self.account.storage.save(
            <-create VaultMinter(),
            to: /storage/CadenceFungibleTokenTutorialMinter
        )
    }
} 