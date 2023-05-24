---
lastUpdated: 0
createdAt: 1681761283669
id: 1:0x03506eD3f57892C85DB20C36846e9c808aFe9ef4:453
website: https://chokepoint.exchange
bannerImg: bafkreieku2kopspxqvlvr4hpj6tnrjegkxny5vaqcjoka6oca7xqhdztey
logoImg: bafkreid6xbaom37fnurpouwz5wckdodnciv3bzeipph36uk27ay6lmzaau
userGithub: chokepoint-exchange
projectGithub: chokepoint-dao
projectTwitter: chokepoint_dao
---

<img style="width: 200px" src="https://ipfs-grants-stack.gitcoin.co/ipfs/bafkreid6xbaom37fnurpouwz5wckdodnciv3bzeipph36uk27ay6lmzaau">

<img src="https://ipfs-grants-stack.gitcoin.co/ipfs/bafkreieku2kopspxqvlvr4hpj6tnrjegkxny5vaqcjoka6oca7xqhdztey">

# chokepoint.exchange
a trustless bridge between CBDC and ETH
# What we're BUIDLing
## Problem: anti-crypto government
Recently, the law enforcements are tightening their attitude towards crypto industry. [FDIC has forcibly closed a crypto-friendly bank Signature Bank without telling them why.](https://decrypt.co/123346/signature-bank-shut-down-anti-crypto-barney-frank) [SEC has sent a wells notice for Coinbase without disclosing what\'s wrong.](https://www.coinbase.com/blog/we-asked-the-sec-for-reasonable-crypto-rules-for-americans-we-got-legal) [Kraken was forced to shut down their staking service due to regulatory pressure.](https://www.theverge.com/2023/2/9/23593183/kraken-staking-sec-settlement-penalties-crypto-interest) [Elizabeth Warren blames crypto for the collapse of Sillicon Valley Bank somehow.](https://twitter.com/ewarren/status/1636488503197413377) It seems that FTX has damaged the sentiment towards crypto among the government insiders severely.
## Consequence: incoming crackdown
The last straw that will break camel's back is for Gary Gensler to declare ETH a security as opposed to a commodity. The legal implication of this would be the biggest since the inception of Ethereum. [He has been talking about his intention to do so publicly for a while.](https://www.protocol.com/newsletters/protocol-fintech/gensler-ether-security) If it were to finally happen, every single exchange that lists ETH might be deemed as illegal. [The state of New York just sued Kucoin for this exact reason.](https://www.coindesk.com/policy/2023/03/09/new-york-attorney-general-sues-crypto-exchange-kucoin-alleges-ether-is-a-security/) [SEC just charged Bittrex saying premined coins are security.](https://www.sec.gov/news/press-release/2023-78) Don't ignore the canary in a coal mine. [The entire market will collapse unless we do something.](https://graymirror.substack.com/p/bitvana-or-the-bitcaust)
## Solution: fiat dex
To save cypherpunks from the government overreach, we are developing chokepoint.exchange, the first trustless non-custodial NoKYC OTC DEX that supports fiat natively without relying on stablecoin which is a single point of failure SEC can easily crack down on. It utilizes the combination of transport layer security and zero knowledge proof outlined in [a paper from Cornell University](https://arxiv.org/abs/1909.00938) to prove on-chain that the buyer has sent the seller CBDC. CBDC transfers to buy ETH on chokepoint.exchange will look indistinguishable from ordinal individual-to-individual transfers, thus it is uncensorable by the government.
# How we build it
no CBDC wallet for consumers has been released yet, but we can assume that it will be accessible through the current internet stack, IP, TCP, HTTP, TLS... Thus verifying on-chain that CBDC transfer has happened could be reducible to verifying on-chain that a certain response has came back from a HTTP server the government operates. Turns out [this exact problem was nailed by a team from Cornell University in 2019](https://arxiv.org/abs/1909.00938), and subsequently [improved by a team from University of Lisbon in 2022](https://eprint.iacr.org/2022/1774.pdf).
## 2023: libchokepoint
We aim to release an open source implementation of the paper by Rust and Lurk in 2023.  It enables the prover to prove to the verifier that the server has responded to the prover's HTTP request with a HTTP response encrypted with a TLS session key derived from the server's TLS certificate. The first release will prove about a whole response from the server, thus it is succinct but not zero knowledge, as it might leak the verifier some critical private information about the prover.
The second release will add zero knowledge property. Assuming the response is structured in JSON or XML, it will prove that a certain key in the response equals to a certain value, without disclosing any values of other keys.
## 2024: chokepoint.exchange
 libchokepoint enables a buyer on chokepoint.exchange to prove to verifiers that he has sent the seller x amount of CBDC, without disclosing any other information. The slight problem here is that it implements an interactive protocol, thus smart contracts can't be a verifier. We mitigate this problem by utilizing EigenLayer restaking. Each restaked node will play the interactive game with buyers as a verifier, verify whether or not the the buyer has actually sent the seller CBDC, vote for the verification result on the chain. The restaked nodes who have voted for the majority will be paid transaction fees. Those who have voted against the majority will be slashed.

> [!info] Metadata
> * website: https://chokepoint.exchange
> * userGithub: chokepoint-exchange
> * projectGithub: chokepoint-dao
> * projectTwitter: chokepoint_dao