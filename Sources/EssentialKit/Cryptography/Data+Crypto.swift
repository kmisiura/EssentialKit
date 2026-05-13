import CryptoKit
import Foundation

public extension Data {

    // MARK: - SHA-2

    /// A SHA-256 digest of the data, returned as a lowercase hex string.
    var sha256: String { Crypto.sha256(self) }

    /// A SHA-384 digest of the data, returned as a lowercase hex string.
    var sha384: String { Crypto.sha384(self) }

    /// A SHA-512 digest of the data, returned as a lowercase hex string.
    var sha512: String { Crypto.sha512(self) }

    // MARK: - SHA-3

    /// A SHA3-256 digest of the data, returned as a lowercase hex string.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    var sha3_256: String { Crypto.sha3_256(self) }

    /// A SHA3-384 digest of the data, returned as a lowercase hex string.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    var sha3_384: String { Crypto.sha3_384(self) }

    /// A SHA3-512 digest of the data, returned as a lowercase hex string.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    var sha3_512: String { Crypto.sha3_512(self) }

    // MARK: - AES-GCM

    /// Encrypts the data using AES-GCM with the given key.
    ///
    /// Returns a sealed blob of `nonce (12B) || ciphertext || tag (16B)`.
    /// Pass the result directly to ``aesGCMDecrypted(using:)`` to recover the original data.
    ///
    /// - Parameter key: A 128, 192, or 256-bit symmetric key.
    /// - Returns: The sealed blob.
    /// - Throws: `CryptoKitError` if the key size is invalid.
    func aesGCMEncrypted(using key: SymmetricKey) throws -> Data {
        try Crypto.aesGCMEncrypt(self, using: key)
    }

    /// Decrypts and authenticates an AES-GCM sealed blob.
    ///
    /// Expects a blob in `nonce (12B) || ciphertext || tag (16B)` format,
    /// as produced by ``aesGCMEncrypted(using:)``.
    ///
    /// - Parameter key: The symmetric key used during encryption.
    /// - Returns: The recovered plaintext.
    /// - Throws: `CryptoKitError.authenticationFailure` if the data has been tampered with.
    func aesGCMDecrypted(using key: SymmetricKey) throws -> Data {
        try Crypto.aesGCMDecrypt(self, using: key)
    }

    // MARK: - ChaCha20-Poly1305

    /// Encrypts the data using ChaCha20-Poly1305 with the given key.
    ///
    /// Returns a sealed blob of `nonce (12B) || ciphertext || tag (16B)`.
    /// Pass the result directly to ``chaChaPolyDecrypted(using:)`` to recover the original data.
    ///
    /// - Parameter key: A 256-bit symmetric key.
    /// - Returns: The sealed blob.
    /// - Throws: `CryptoKitError` if the key size is not 256 bits.
    func chaChaPolyEncrypted(using key: SymmetricKey) throws -> Data {
        try Crypto.chaChaPolyEncrypt(self, using: key)
    }

    /// Decrypts and authenticates a ChaCha20-Poly1305 sealed blob.
    ///
    /// Expects a blob in `nonce (12B) || ciphertext || tag (16B)` format,
    /// as produced by ``chaChaPolyEncrypted(using:)``.
    ///
    /// - Parameter key: The 256-bit symmetric key used during encryption.
    /// - Returns: The recovered plaintext.
    /// - Throws: `CryptoKitError.authenticationFailure` if the data has been tampered with.
    func chaChaPolyDecrypted(using key: SymmetricKey) throws -> Data {
        try Crypto.chaChaPolyDecrypt(self, using: key)
    }

    // MARK: - P-256 Signing

    /// Signs the data using ECDSA over P-256 and returns a DER-encoded signature.
    ///
    /// - Parameter privateKey: The P-256 private signing key.
    /// - Returns: The ECDSA signature in DER encoding.
    /// - Throws: `CryptoKitError` if signing fails.
    func p256Signed(using privateKey: P256.Signing.PrivateKey) throws -> Data {
        try Crypto.p256Sign(self, using: privateKey)
    }

    /// Verifies a DER-encoded P-256 ECDSA signature against the data.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature.
    ///   - publicKey: The P-256 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func p256VerifySignature(_ signature: Data, using publicKey: P256.Signing.PublicKey) -> Bool {
        Crypto.p256Verify(signature, for: self, using: publicKey)
    }

    // MARK: - P-384 Signing

    /// Signs the data using ECDSA over P-384 and returns a DER-encoded signature.
    ///
    /// - Parameter privateKey: The P-384 private signing key.
    /// - Returns: The ECDSA signature in DER encoding.
    /// - Throws: `CryptoKitError` if signing fails.
    func p384Signed(using privateKey: P384.Signing.PrivateKey) throws -> Data {
        try Crypto.p384Sign(self, using: privateKey)
    }

    /// Verifies a DER-encoded P-384 ECDSA signature against the data.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature.
    ///   - publicKey: The P-384 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func p384VerifySignature(_ signature: Data, using publicKey: P384.Signing.PublicKey) -> Bool {
        Crypto.p384Verify(signature, for: self, using: publicKey)
    }

    // MARK: - P-521 Signing

    /// Signs the data using ECDSA over P-521 and returns a DER-encoded signature.
    ///
    /// - Parameter privateKey: The P-521 private signing key.
    /// - Returns: The ECDSA signature in DER encoding.
    /// - Throws: `CryptoKitError` if signing fails.
    func p521Signed(using privateKey: P521.Signing.PrivateKey) throws -> Data {
        try Crypto.p521Sign(self, using: privateKey)
    }

    /// Verifies a DER-encoded P-521 ECDSA signature against the data.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature.
    ///   - publicKey: The P-521 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func p521VerifySignature(_ signature: Data, using publicKey: P521.Signing.PublicKey) -> Bool {
        Crypto.p521Verify(signature, for: self, using: publicKey)
    }

    // MARK: - Ed25519 Signing

    /// Signs the data using Ed25519 and returns the 64-byte raw signature.
    ///
    /// - Parameter privateKey: The Ed25519 private signing key.
    /// - Returns: The 64-byte raw Ed25519 signature.
    /// - Throws: `CryptoKitError` if signing fails.
    func ed25519Signed(using privateKey: Curve25519.Signing.PrivateKey) throws -> Data {
        try Crypto.ed25519Sign(self, using: privateKey)
    }

    /// Verifies a raw Ed25519 signature against the data.
    ///
    /// - Parameters:
    ///   - signature: The 64-byte raw Ed25519 signature.
    ///   - publicKey: The Ed25519 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func ed25519VerifySignature(_ signature: Data, using publicKey: Curve25519.Signing.PublicKey) -> Bool {
        Crypto.ed25519Verify(signature, for: self, using: publicKey)
    }
}
