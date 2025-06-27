# Asynchronous FIFO

## Overview

This project implements an **Asynchronous FIFO (First-In, First-Out)** buffer designed to enable safe and efficient data transfer between two independent clock domains. The FIFO is especially useful in digital systems where the **write clock is faster than the read clock**, and there is a risk of data corruption or loss due to asynchronous timing.

## Key Features

- Handles **asynchronous clock domains** (separate clocks for write and read).
- Prevents **data loss and metastability** through careful synchronization.
- Modular design with clean separation of responsibilities.

## Modules Description

The FIFO is composed of **four main modules**, each playing a critical role in ensuring correct operation across clock domains:

### FIFO Memory

- A dual-port memory that stores the data entries.
- Simultaneous access for writing and reading using separate clocks.

### FIFO Write Logic

- Operates in the **write clock domain**.
- Maintains the **write pointer** and generates the **full flag**.
- Determines whether new data can be written based on FIFO status.

### FIFO Read Logic

- Operates in the **read clock domain**.
- Maintains the **read pointer** and generates the **empty flag**.
- Controls when valid data can be read.

### Data Synchronizer

- Ensures safe transfer of control signals (like read/write pointers) between the asynchronous domains.
- Avoids metastability by using multi-flop synchronizers for pointer comparisons.
