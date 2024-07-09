# Decentralized Labor Market Protocol - Proof of Concept

## Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Key Components](#key-components)
4. [Data Flow](#data-flow)
5. [Technical Specifications](#technical-specifications)
6. [Interesting Notes/Links](#interesting-notes)

## Overview

The Decentralized Labor Market System is a peer-to-peer platform enabling employers and workers to connect, negotiate, and complete job contracts without centralized intermediaries. It leverages blockchain technology for secure transactions and a decentralized reputation system, while using a peer-to-peer network for efficient job discovery and communication. This is a brief overview of the system.

## System Architecture

![architecture](https://github.com/elijahhampton/opportunity-design/assets/26151387/1d773de7-cd2c-4c01-ba11-f90a7b2b7f2f)


The system consists of four main components:

1. Node Software (Core Application)
2. Peer-to-Peer Network
3. Blockchain Layer

## Key Components

### 1. Node Software

- **Language**: Rust
- **Key Modules**:
  - Profile Manager
  - Job/Skill Manager
  - P2P Communication Module
  - Blockchain Interface
  - Local API Server
  - Cryptography Module

### 2. Peer-to-Peer Network

- **Protocol**: libp2p
- **Key Features**:
  - Kademlia DHT for peer discovery
  - GossipSub for message propagation
  - Direct messaging for negotiations

### 3. Blockchain Layer

- **Platform**: StarkNet (Layer 2 scaling solution for Ethereum)
- **Smart Contracts** (written in Cairo):
  - Job/Escrow Contract
  - Reputation Contract

## Data Flow

### Job Posting Process

1. Employer creates job posting
2. Job is broadcast to P2P network

### Job Discovery and Application

1. Worker discovers job via P2P network
   2a. Worker applies through direct P2P messaging
   2a1. Employer receives application notification
   2a2. Employer accepts work through "accept()"
   2a3. Employer completes work through "complete()"

2b. Employer accepts work through smart contract "complete()"

### Job Acceptance and Completion

1. Employer accepts application
2. Payment is escrowed
3. Job is completed and payment released
4. Reputation scores are updated

## Technical Specifications

### Data Structures

- Job Offer
- Skill Offer
- User Profile

### P2P Protocol

- Custom protocol built on libp2p
- Message types: JOB_OFFER, SKILL_OFFER, APPLICATION, etc.

### Local Storage

- Database: LevelDB
- Key-Value pairs for profiles, jobs, skills, and reputation

### Interesting Notes/Links
