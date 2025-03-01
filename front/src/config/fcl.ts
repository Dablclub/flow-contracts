import { config } from "@onflow/fcl";

config()
  .put("accessNode.api", "https://rest-testnet.onflow.org")
  .put("discovery.wallet", "https://fcl-discovery.onflow.org/testnet/authn")
  .put("app.detail.title", "Flow Token & NFT Minter")
  .put("app.detail.icon", "https://placekitten.com/g/200/200")
  .put("0xExampleToken", "0xb6fba1379cc97f72");

config()
  .put("0xBasicNFT", "0xb6fba1379cc97f72"); // Your NFT contract address 