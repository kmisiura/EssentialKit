import CryptoKit
import Foundation

public extension String {

    // MARK: - SHA-2

    /// A SHA-256 digest of the string's UTF-8 representation, returned as a lowercase hex string.
    var sha256: String { Crypto.sha256(self) }

    /// A SHA-384 digest of the string's UTF-8 representation, returned as a lowercase hex string.
    var sha384: String { Crypto.sha384(self) }

    /// A SHA-512 digest of the string's UTF-8 representation, returned as a lowercase hex string.
    var sha512: String { Crypto.sha512(self) }

    // MARK: - SHA-3

    /// A SHA3-256 digest of the string's UTF-8 representation, returned as a lowercase hex string.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    var sha3_256: String { Crypto.sha3_256(self) }

    /// A SHA3-384 digest of the string's UTF-8 representation, returned as a lowercase hex string.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    var sha3_384: String { Crypto.sha3_384(self) }

    /// A SHA3-512 digest of the string's UTF-8 representation, returned as a lowercase hex string.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    var sha3_512: String { Crypto.sha3_512(self) }

    // MARK: - AES-GCM

    /// Encrypts the string's UTF-8 representation using AES-GCM with the given key.
    ///
    /// Returns a sealed blob of `nonce (12B) || ciphertext || tag (16B)`.
    /// To recover the original string, decrypt the blob with `Data.aesGCMDecrypted(using:)`
    /// and initialise a `String` from the resulting UTF-8 data.
    ///
    /// - Parameter key: A 128, 192, or 256-bit symmetric key.
    /// - Returns: The sealed blob.
    /// - Throws: `CryptoKitError` if the key size is invalid.
    func aesGCMEncrypted(using key: SymmetricKey) throws -> Data {
        try Crypto.aesGCMEncrypt(Data(utf8), using: key)
    }

    // MARK: - ChaCha20-Poly1305

    /// Encrypts the string's UTF-8 representation using ChaCha20-Poly1305 with the given key.
    ///
    /// Returns a sealed blob of `nonce (12B) || ciphertext || tag (16B)`.
    /// To recover the original string, decrypt the blob with `Data.chaChaPolyDecrypted(using:)`
    /// and initialise a `String` from the resulting UTF-8 data.
    ///
    /// - Parameter key: A 256-bit symmetric key.
    /// - Returns: The sealed blob.
    /// - Throws: `CryptoKitError` if the key size is not 256 bits.
    func chaChaPolyEncrypted(using key: SymmetricKey) throws -> Data {
        try Crypto.chaChaPolyEncrypt(Data(utf8), using: key)
    }

    // MARK: - P-256 Signing

    /// Signs the string's UTF-8 representation using ECDSA over P-256.
    ///
    /// - Parameter privateKey: The P-256 private signing key.
    /// - Returns: The DER-encoded ECDSA signature.
    /// - Throws: `CryptoKitError` if signing fails.
    func p256Signed(using privateKey: P256.Signing.PrivateKey) throws -> Data {
        try Crypto.p256Sign(Data(utf8), using: privateKey)
    }

    /// Verifies a DER-encoded P-256 ECDSA signature against the string's UTF-8 representation.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature.
    ///   - publicKey: The P-256 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func p256VerifySignature(_ signature: Data, using publicKey: P256.Signing.PublicKey) -> Bool {
        Crypto.p256Verify(signature, for: Data(utf8), using: publicKey)
    }

    // MARK: - P-384 Signing

    /// Signs the string's UTF-8 representation using ECDSA over P-384.
    ///
    /// - Parameter privateKey: The P-384 private signing key.
    /// - Returns: The DER-encoded ECDSA signature.
    /// - Throws: `CryptoKitError` if signing fails.
    func p384Signed(using privateKey: P384.Signing.PrivateKey) throws -> Data {
        try Crypto.p384Sign(Data(utf8), using: privateKey)
    }

    /// Verifies a DER-encoded P-384 ECDSA signature against the string's UTF-8 representation.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature.
    ///   - publicKey: The P-384 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func p384VerifySignature(_ signature: Data, using publicKey: P384.Signing.PublicKey) -> Bool {
        Crypto.p384Verify(signature, for: Data(utf8), using: publicKey)
    }

    // MARK: - P-521 Signing

    /// Signs the string's UTF-8 representation using ECDSA over P-521.
    ///
    /// - Parameter privateKey: The P-521 private signing key.
    /// - Returns: The DER-encoded ECDSA signature.
    /// - Throws: `CryptoKitError` if signing fails.
    func p521Signed(using privateKey: P521.Signing.PrivateKey) throws -> Data {
        try Crypto.p521Sign(Data(utf8), using: privateKey)
    }

    /// Verifies a DER-encoded P-521 ECDSA signature against the string's UTF-8 representation.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature.
    ///   - publicKey: The P-521 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func p521VerifySignature(_ signature: Data, using publicKey: P521.Signing.PublicKey) -> Bool {
        Crypto.p521Verify(signature, for: Data(utf8), using: publicKey)
    }

    // MARK: - Ed25519 Signing

    /// Signs the string's UTF-8 representation using Ed25519.
    ///
    /// - Parameter privateKey: The Ed25519 private signing key.
    /// - Returns: The 64-byte raw Ed25519 signature.
    /// - Throws: `CryptoKitError` if signing fails.
    func ed25519Signed(using privateKey: Curve25519.Signing.PrivateKey) throws -> Data {
        try Crypto.ed25519Sign(Data(utf8), using: privateKey)
    }

    /// Verifies a raw Ed25519 signature against the string's UTF-8 representation.
    ///
    /// - Parameters:
    ///   - signature: The 64-byte raw Ed25519 signature.
    ///   - publicKey: The Ed25519 public key corresponding to the signing key.
    /// - Returns: `true` if the signature is valid.
    func ed25519VerifySignature(_ signature: Data, using publicKey: Curve25519.Signing.PublicKey) -> Bool {
        Crypto.ed25519Verify(signature, for: Data(utf8), using: publicKey)
    }
}
