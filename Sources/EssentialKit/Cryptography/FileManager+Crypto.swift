import CryptoKit
import Foundation

public extension FileManager {

    // MARK: - File Hashing (SHA-2)

    /// Computes a SHA-256 digest of the file at the given URL using memory-efficient chunked reading.
    ///
    /// Reads the file in 1 MB chunks so the entire file is never held in memory at once,
    /// making this suitable for large files.
    ///
    /// **Best use cases:** Verifying download integrity, content-addressed caching, detecting
    /// file changes without loading the full content.
    ///
    /// - Parameter url: The URL of the file to hash. Must be a local file URL.
    /// - Returns: A 64-character lowercase hexadecimal SHA-256 digest.
    /// - Throws: An error if the file cannot be opened or read.
    func sha256(at url: URL) throws -> String {
        try incrementalHash(using: SHA256.self, at: url)
    }

    /// Computes a SHA-384 digest of the file at the given URL using memory-efficient chunked reading.
    ///
    /// Reads the file in 1 MB chunks so the entire file is never held in memory at once.
    ///
    /// **Best use cases:** High-assurance integrity checks in financial or government contexts
    /// where SHA-256 collision resistance is deemed insufficient.
    ///
    /// - Parameter url: The URL of the file to hash. Must be a local file URL.
    /// - Returns: A 96-character lowercase hexadecimal SHA-384 digest.
    /// - Throws: An error if the file cannot be opened or read.
    func sha384(at url: URL) throws -> String {
        try incrementalHash(using: SHA384.self, at: url)
    }

    /// Computes a SHA-512 digest of the file at the given URL using memory-efficient chunked reading.
    ///
    /// Reads the file in 1 MB chunks so the entire file is never held in memory at once.
    ///
    /// **Best use cases:** Long-term archival integrity, signing large files, and constructions
    /// where the full 512-bit output is required.
    ///
    /// - Parameter url: The URL of the file to hash. Must be a local file URL.
    /// - Returns: A 128-character lowercase hexadecimal SHA-512 digest.
    /// - Throws: An error if the file cannot be opened or read.
    func sha512(at url: URL) throws -> String {
        try incrementalHash(using: SHA512.self, at: url)
    }

    // MARK: - File Hashing (SHA-3)

    /// Computes a SHA3-256 digest of the file at the given URL using memory-efficient chunked reading.
    ///
    /// SHA3-256 uses the Keccak sponge construction and is immune to length-extension attacks.
    /// Reads the file in 1 MB chunks.
    ///
    /// - Parameter url: The URL of the file to hash. Must be a local file URL.
    /// - Returns: A 64-character lowercase hexadecimal SHA3-256 digest.
    /// - Throws: An error if the file cannot be opened or read.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func sha3_256(at url: URL) throws -> String {
        try incrementalHash(using: SHA3_256.self, at: url)
    }

    /// Computes a SHA3-384 digest of the file at the given URL using memory-efficient chunked reading.
    ///
    /// SHA3-384 uses the Keccak sponge construction and provides 192-bit collision resistance.
    /// Reads the file in 1 MB chunks.
    ///
    /// - Parameter url: The URL of the file to hash. Must be a local file URL.
    /// - Returns: A 96-character lowercase hexadecimal SHA3-384 digest.
    /// - Throws: An error if the file cannot be opened or read.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func sha3_384(at url: URL) throws -> String {
        try incrementalHash(using: SHA3_384.self, at: url)
    }

    /// Computes a SHA3-512 digest of the file at the given URL using memory-efficient chunked reading.
    ///
    /// SHA3-512 offers the highest security margin in CryptoKit and is resistant to both
    /// length-extension and quantum-era Grover attacks. Reads the file in 1 MB chunks.
    ///
    /// - Parameter url: The URL of the file to hash. Must be a local file URL.
    /// - Returns: A 128-character lowercase hexadecimal SHA3-512 digest.
    /// - Throws: An error if the file cannot be opened or read.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func sha3_512(at url: URL) throws -> String {
        try incrementalHash(using: SHA3_512.self, at: url)
    }

    // MARK: - AES-GCM File Encryption

    /// Encrypts the file at `sourceURL` using AES-GCM and writes the sealed blob to `destinationURL`.
    ///
    /// The output file has the layout: `nonce (12B) || ciphertext || tag (16B)`.
    /// Pass the output file directly to ``aesGCMDecrypt(at:to:using:)`` to recover the original.
    ///
    /// - Note: The source file is loaded fully into memory before encryption. For files larger
    ///   than available RAM, consider a chunked streaming approach.
    ///
    /// - Parameters:
    ///   - sourceURL: The URL of the plaintext file to encrypt.
    ///   - destinationURL: The URL where the encrypted file will be written.
    ///   - key: A 128, 192, or 256-bit symmetric key.
    /// - Throws: A file or `CryptoKitError` if the source cannot be read, the key size is
    ///   invalid, or the destination cannot be written.
    func aesGCMEncrypt(at sourceURL: URL, to destinationURL: URL, using key: SymmetricKey) throws {
        let plaintext = try Data(contentsOf: sourceURL)
        let sealed = try Crypto.aesGCMEncrypt(plaintext, using: key)
        try sealed.write(to: destinationURL)
    }

    /// Decrypts and authenticates an AES-GCM encrypted file, writing the plaintext to `destinationURL`.
    ///
    /// Expects a file produced by ``aesGCMEncrypt(at:to:using:)`` in
    /// `nonce (12B) || ciphertext || tag (16B)` format. Decryption fails if the file has been
    /// tampered with, ensuring integrity is verified before any plaintext is written.
    ///
    /// - Note: The encrypted file is loaded fully into memory before decryption.
    ///
    /// - Parameters:
    ///   - sourceURL: The URL of the AES-GCM encrypted file.
    ///   - destinationURL: The URL where the decrypted plaintext will be written.
    ///   - key: The symmetric key used during encryption.
    /// - Throws: `CryptoKitError.authenticationFailure` if the file has been tampered with,
    ///   or a file error if the source cannot be read or destination cannot be written.
    func aesGCMDecrypt(at sourceURL: URL, to destinationURL: URL, using key: SymmetricKey) throws {
        let sealed = try Data(contentsOf: sourceURL)
        let plaintext = try Crypto.aesGCMDecrypt(sealed, using: key)
        try plaintext.write(to: destinationURL)
    }

    // MARK: - ChaCha20-Poly1305 File Encryption

    /// Encrypts the file at `sourceURL` using ChaCha20-Poly1305 and writes the sealed blob to `destinationURL`.
    ///
    /// The output file has the layout: `nonce (12B) || ciphertext || tag (16B)`.
    /// Pass the output file directly to ``chaChaPolyDecrypt(at:to:using:)`` to recover the original.
    ///
    /// ChaCha20-Poly1305 provides equivalent security to AES-256-GCM without requiring hardware
    /// AES acceleration, making it well-suited for devices where constant-time software
    /// cryptography is preferred.
    ///
    /// - Note: The source file is loaded fully into memory before encryption.
    ///
    /// - Parameters:
    ///   - sourceURL: The URL of the plaintext file to encrypt.
    ///   - destinationURL: The URL where the encrypted file will be written.
    ///   - key: A 256-bit symmetric key.
    /// - Throws: A file or `CryptoKitError` if the source cannot be read, the key is not
    ///   256 bits, or the destination cannot be written.
    func chaChaPolyEncrypt(at sourceURL: URL, to destinationURL: URL, using key: SymmetricKey) throws {
        let plaintext = try Data(contentsOf: sourceURL)
        let sealed = try Crypto.chaChaPolyEncrypt(plaintext, using: key)
        try sealed.write(to: destinationURL)
    }

    /// Decrypts and authenticates a ChaCha20-Poly1305 encrypted file, writing the plaintext to `destinationURL`.
    ///
    /// Expects a file produced by ``chaChaPolyEncrypt(at:to:using:)`` in
    /// `nonce (12B) || ciphertext || tag (16B)` format. Decryption fails if the file has been
    /// tampered with.
    ///
    /// - Note: The encrypted file is loaded fully into memory before decryption.
    ///
    /// - Parameters:
    ///   - sourceURL: The URL of the ChaCha20-Poly1305 encrypted file.
    ///   - destinationURL: The URL where the decrypted plaintext will be written.
    ///   - key: The 256-bit symmetric key used during encryption.
    /// - Throws: `CryptoKitError.authenticationFailure` if the file has been tampered with,
    ///   or a file error if the source cannot be read or destination cannot be written.
    func chaChaPolyDecrypt(at sourceURL: URL, to destinationURL: URL, using key: SymmetricKey) throws {
        let sealed = try Data(contentsOf: sourceURL)
        let plaintext = try Crypto.chaChaPolyDecrypt(sealed, using: key)
        try plaintext.write(to: destinationURL)
    }
}

// MARK: - Private Helpers

private extension FileManager {

    static let chunkSize = 1024 * 1024 // 1 MB

    /// Hashes a file incrementally using the given `HashFunction`, reading in fixed-size chunks.
    func incrementalHash<H: HashFunction>(using _: H.Type, at url: URL) throws -> String {
        let fileHandle = try FileHandle(forReadingFrom: url)
        defer { try? fileHandle.close() }

        var hasher = H()
        while true {
            let chunk = fileHandle.readData(ofLength: Self.chunkSize)
            guard !chunk.isEmpty else { break }
            hasher.update(data: chunk)
        }
        return hasher.finalize().map { String(format: "%02hhx", $0) }.joined()
    }
}
