'use client';
import './globals.css';
import Head from 'next/head';
import { Inter } from 'next/font/google';
import Image from 'next/image';
import {
  ThirdwebProvider,
  metamaskWallet,
} from "@thirdweb-dev/react";
import { ChainId } from "@thirdweb-dev/sdk";
import { PolygonAmoyTestnet } from "@thirdweb-dev/chains";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import {MantaPacific} from "../../components/mantaEth";
import { createWeb3Modal } from "@web3modal/wagmi/react";
import { defaultWagmiConfig } from "@web3modal/wagmi/react/config";
import { WagmiProvider } from "wagmi";

const inter = Inter({ subsets: ['latin'] });

export default function RootLayout({
  children,
}) {

  const activeChainId = ChainId.Mumbai;
  const queryClient = new QueryClient();
  const projectId = process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID;

  const metadata = {
    name: "Tarot",
    description: "Tarot",
    url: "http://localhost",
    icons: ["https://avatars.githubusercontent.com/u/37784886"],
  };

  // const chains = [polygonAmoy];
const chains = [MantaPacific];
const config = defaultWagmiConfig({
  chains,
  projectId,
  metadata,
});

createWeb3Modal({
  wagmiConfig: config,
  projectId,
  enableAnalytics: true,
  enableOnramp: true,
});

  return (
      <html lang="en">
        <Head>
          <title>SNL</title>
          <meta
            name="description"
            content="An app where users are able to discover something new and receive an NFT to show off their achievement."
          />
        </Head>
        <body
          className={`bg-gradient bg-cover bg-no-repeat w-full min-h-screen flex justify-between h-screen flex-col items-center ${inter.className}`}
        >
          <div className='w-full'>
          <QueryClientProvider client={queryClient}>
            
          <ThirdwebProvider>
          <WagmiProvider config={config}>

{children}
</WagmiProvider>
</ThirdwebProvider>
        </QueryClientProvider>
        </div>
        </body>
      </html>
  );
}