import CryptoKit
import Foundation
import OSLogger

public struct Crypto {

    // MARK: - SHA-2

    /// Computes a SHA-256 digest of the given data and returns it as a lowercase hex string.
    ///
    /// SHA-256 is part of the SHA-2 family and produces a 256-bit (32-byte) digest. It offers
    /// a strong balance between security and performance, making it the most widely deployed
    /// hash function today.
    ///
    /// **Best use cases:** General-purpose integrity verification, digital signatures, certificate
    /// fingerprints, password hashing (paired with a KDF like PBKDF2 or Argon2), and
    /// content-addressed storage.
    ///
    /// - Parameter data: The data to hash.
    /// - Returns: A 64-character lowercase hexadecimal string representing the SHA-256 digest.
    static public func sha256(_ data: Data) -> String {
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    /// Computes a SHA-256 digest of the UTF-8 representation of the given string.
    ///
    /// SHA-256 is part of the SHA-2 family and produces a 256-bit (32-byte) digest. It offers
    /// a strong balance between security and performance, making it the most widely deployed
    /// hash function today.
    ///
    /// **Best use cases:** Hashing string tokens, API keys, or any text-based payload where
    /// a compact, fixed-length fingerprint is needed.
    ///
    /// - Parameter string: The string whose UTF-8 encoding will be hashed.
    /// - Returns: A 64-character lowercase hexadecimal string representing the SHA-256 digest.
    static public func sha256(_ string: String) -> String {
        sha256(Data(string.utf8))
    }

    /// Computes a SHA-384 digest of the given data and returns it as a lowercase hex string.
    ///
    /// SHA-384 is a truncated variant of SHA-512 in the SHA-2 family, producing a 384-bit
    /// (48-byte) digest. It provides a higher security margin than SHA-256 while using the
    /// same 64-bit word operations as SHA-512, making it efficient on 64-bit processors.
    ///
    /// **Best use cases:** TLS certificate signing, government and financial applications
    /// requiring stronger guarantees than SHA-256, and scenarios where 256-bit collision
    /// resistance is insufficient.
    ///
    /// - Parameter data: The data to hash.
    /// - Returns: A 96-character lowercase hexadecimal string representing the SHA-384 digest.
    static public func sha384(_ data: Data) -> String {
        let digest = SHA384.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    /// Computes a SHA-384 digest of the UTF-8 representation of the given string.
    ///
    /// SHA-384 is a truncated variant of SHA-512 in the SHA-2 family, producing a 384-bit
    /// (48-byte) digest. It provides a higher security margin than SHA-256 while using the
    /// same 64-bit word operations as SHA-512, making it efficient on 64-bit processors.
    ///
    /// **Best use cases:** Hashing sensitive string data in high-assurance contexts such as
    /// financial transactions or identity documents.
    ///
    /// - Parameter string: The string whose UTF-8 encoding will be hashed.
    /// - Returns: A 96-character lowercase hexadecimal string representing the SHA-384 digest.
    static public func sha384(_ string: String) -> String {
        sha384(Data(string.utf8))
    }

    /// Computes a SHA-512 digest of the given data and returns it as a lowercase hex string.
    ///
    /// SHA-512 is part of the SHA-2 family and produces a 512-bit (64-byte) digest — the
    /// largest in the family. It operates on 64-bit words and is often faster than SHA-256
    /// on 64-bit hardware despite producing a larger output.
    ///
    /// **Best use cases:** Long-term archival integrity, cryptographic protocols requiring
    /// maximum collision resistance (e.g., signing large files), and constructions where
    /// the full 512-bit output is consumed by a downstream algorithm.
    ///
    /// - Parameter data: The data to hash.
    /// - Returns: A 128-character lowercase hexadecimal string representing the SHA-512 digest.
    static public func sha512(_ data: Data) -> String {
        let digest = SHA512.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    /// Computes a SHA-512 digest of the UTF-8 representation of the given string.
    ///
    /// SHA-512 is part of the SHA-2 family and produces a 512-bit (64-byte) digest — the
    /// largest in the family. It operates on 64-bit words and is often faster than SHA-256
    /// on 64-bit hardware despite producing a larger output.
    ///
    /// **Best use cases:** Hashing string content where maximum digest strength is required,
    /// such as master secrets or root keys in a key derivation hierarchy.
    ///
    /// - Parameter string: The string whose UTF-8 encoding will be hashed.
    /// - Returns: A 128-character lowercase hexadecimal string representing the SHA-512 digest.
    static public func sha512(_ string: String) -> String {
        sha512(Data(string.utf8))
    }

    // MARK: - SHA-3

    /// Computes a SHA3-256 digest of the given data and returns it as a lowercase hex string.
    ///
    /// SHA3-256 is part of the SHA-3 family (NIST FIPS 202), which is based on the Keccak
    /// sponge construction — an entirely different internal design from SHA-2. It produces
    /// a 256-bit (32-byte) digest and is immune to length-extension attacks that affect SHA-2.
    ///
    /// **Best use cases:** Applications that need a SHA-256–sized digest but want algorithmic
    /// diversity as a hedge against future SHA-2 weaknesses, blockchain and cryptocurrency
    /// protocols, and any system requiring NIST post-2015 compliance.
    ///
    /// - Parameter data: The data to hash.
    /// - Returns: A 64-character lowercase hexadecimal string representing the SHA3-256 digest.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    static public func sha3_256(_ data: Data) -> String {
        let digest = SHA3_256.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    /// Computes a SHA3-256 digest of the UTF-8 representation of the given string.
    ///
    /// SHA3-256 is part of the SHA-3 family (NIST FIPS 202), which is based on the Keccak
    /// sponge construction — an entirely different internal design from SHA-2. It produces
    /// a 256-bit (32-byte) digest and is immune to length-extension attacks that affect SHA-2.
    ///
    /// **Best use cases:** Hashing string identifiers or tokens in systems that mandate
    /// algorithmic agility or explicit SHA-3 compliance.
    ///
    /// - Parameter string: The string whose UTF-8 encoding will be hashed.
    /// - Returns: A 64-character lowercase hexadecimal string representing the SHA3-256 digest.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    static public func sha3_256(_ string: String) -> String {
        sha3_256(Data(string.utf8))
    }

    /// Computes a SHA3-384 digest of the given data and returns it as a lowercase hex string.
    ///
    /// SHA3-384 is part of the SHA-3 family (NIST FIPS 202) and produces a 384-bit (48-byte)
    /// digest using the Keccak sponge construction. It combines the larger digest size of
    /// SHA-384 with the structural independence of SHA-3, providing resistance to both
    /// classical and length-extension attacks.
    ///
    /// **Best use cases:** High-assurance environments (government, defence, finance) that
    /// require both a larger digest and SHA-3 algorithmic diversity, and protocols that pair
    /// this hash with 384-bit elliptic curve keys (e.g., P-384).
    ///
    /// - Parameter data: The data to hash.
    /// - Returns: A 96-character lowercase hexadecimal string representing the SHA3-384 digest.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    static public func sha3_384(_ data: Data) -> String {
        let digest = SHA3_384.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    /// Computes a SHA3-384 digest of the UTF-8 representation of the given string.
    ///
    /// SHA3-384 is part of the SHA-3 family (NIST FIPS 202) and produces a 384-bit (48-byte)
    /// digest using the Keccak sponge construction. It combines the larger digest size of
    /// SHA-384 with the structural independence of SHA-3, providing resistance to both
    /// classical and length-extension attacks.
    ///
    /// **Best use cases:** Hashing sensitive string material where both 384-bit strength and
    /// SHA-3 compliance are mandated by a security policy.
    ///
    /// - Parameter string: The string whose UTF-8 encoding will be hashed.
    /// - Returns: A 96-character lowercase hexadecimal string representing the SHA3-384 digest.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    static public func sha3_384(_ string: String) -> String {
        sha3_384(Data(string.utf8))
    }

    /// Computes a SHA3-512 digest of the given data and returns it as a lowercase hex string.
    ///
    /// SHA3-512 is part of the SHA-3 family (NIST FIPS 202) and produces a 512-bit (64-byte)
    /// digest using the Keccak sponge construction. It offers the highest security margin
    /// available in CryptoKit and is resistant to both length-extension and quantum-era
    /// Grover's algorithm attacks (which halve effective digest strength).
    ///
    /// **Best use cases:** Root-of-trust computations, long-lived archive integrity, and any
    /// context where 256-bit post-quantum collision resistance is required alongside SHA-3
    /// algorithmic independence from SHA-2.
    ///
    /// - Parameter data: The data to hash.
    /// - Returns: A 128-character lowercase hexadecimal string representing the SHA3-512 digest.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    static public func sha3_512(_ data: Data) -> String {
        let digest = SHA3_512.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    /// Computes a SHA3-512 digest of the UTF-8 representation of the given string.
    ///
    /// SHA3-512 is part of the SHA-3 family (NIST FIPS 202) and produces a 512-bit (64-byte)
    /// digest using the Keccak sponge construction. It offers the highest security margin
    /// available in CryptoKit and is resistant to both length-extension and quantum-era
    /// Grover's algorithm attacks (which halve effective digest strength).
    ///
    /// **Best use cases:** Hashing master secrets, root keys, or any string whose long-term
    /// integrity must be guaranteed against both classical and quantum adversaries.
    ///
    /// - Parameter string: The string whose UTF-8 encoding will be hashed.
    /// - Returns: A 128-character lowercase hexadecimal string representing the SHA3-512 digest.
    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    static public func sha3_512(_ string: String) -> String {
        sha3_512(Data(string.utf8))
    }

    // MARK: - Symmetric Key Generation

    /// Generates a cryptographically secure random symmetric key.
    ///
    /// The key is generated using the system's cryptographically secure random number generator
    /// and is suitable for use with both ``aesGCMEncrypt(_:using:)`` and
    /// ``chaChaPolyEncrypt(_:using:)``.
    ///
    /// **Best use cases:** Generating session keys, file encryption keys, or any scenario
    /// where a fresh symmetric key is needed. Store the key securely in the Keychain — never
    /// in `UserDefaults` or plain files.
    ///
    /// - Parameter size: The key size. Defaults to 256 bits, which is recommended for both
    ///   AES-GCM and ChaCha20-Poly1305.
    /// - Returns: A new ``SymmetricKey`` of the requested size.
    static public func generateSymmetricKey(size: SymmetricKeySize = .bits256) -> SymmetricKey {
        SymmetricKey(size: size)
    }

    // MARK: - AES-GCM

    /// Encrypts data using AES-GCM with a random 96-bit nonce.
    ///
    /// AES-GCM (Advanced Encryption Standard in Galois/Counter Mode) is an authenticated
    /// encryption scheme that simultaneously encrypts the plaintext and produces a 128-bit
    /// authentication tag. It guarantees both confidentiality and integrity — any tampering
    /// with the ciphertext is detected on decryption.
    ///
    /// The returned blob has the layout: `nonce (12 bytes) || ciphertext || tag (16 bytes)`.
    /// Pass the entire blob directly to ``aesGCMDecrypt(_:using:)`` — no splitting required.
    ///
    /// **Best use cases:** Encrypting files, database fields, network payloads, or any
    /// scenario that requires high-throughput authenticated encryption. AES-GCM is hardware-
    /// accelerated on all Apple platforms via AES-NI / ARMv8 Crypto Extensions.
    ///
    /// - Warning: Never reuse the same key + nonce pair. A fresh random nonce is generated
    ///   automatically on every call, making accidental reuse extremely unlikely.
    ///
    /// - Parameters:
    ///   - data: The plaintext data to encrypt.
    ///   - key: The symmetric key. Must be 128, 192, or 256 bits.
    /// - Returns: The sealed blob: `nonce || ciphertext || tag`.
    /// - Throws: `CryptoKitError` if the key size is invalid.
    static public func aesGCMEncrypt(_ data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return Data(sealedBox.nonce) + sealedBox.ciphertext + sealedBox.tag
    }

    /// Decrypts and authenticates an AES-GCM sealed blob.
    ///
    /// Expects the blob produced by ``aesGCMEncrypt(_:using:)``:
    /// `nonce (12 bytes) || ciphertext || tag (16 bytes)`.
    ///
    /// Decryption fails with an `authenticationFailure` error if the ciphertext or tag has
    /// been tampered with, ensuring integrity is always verified before any plaintext is
    /// returned.
    ///
    /// - Parameters:
    ///   - data: The sealed blob to decrypt.
    ///   - key: The same symmetric key used during encryption.
    /// - Returns: The recovered plaintext.
    /// - Throws: `CryptoKitError.authenticationFailure` if authentication fails, or another
    ///   `CryptoKitError` if the data is malformed.
    static public func aesGCMDecrypt(_ data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }

    // MARK: - ChaCha20-Poly1305

    /// Encrypts data using ChaCha20-Poly1305 with a random 96-bit nonce.
    ///
    /// ChaCha20-Poly1305 is a modern authenticated stream cipher designed by Daniel J. Bernstein.
    /// It provides equivalent security to AES-256-GCM without relying on hardware AES
    /// acceleration, making it the preferred choice on devices where AES instructions are
    /// unavailable or when resistance to timing side-channels is a concern.
    ///
    /// The returned blob has the layout: `nonce (12 bytes) || ciphertext || tag (16 bytes)`.
    /// Pass the entire blob directly to ``chaChaPolyDecrypt(_:using:)`` — no splitting required.
    ///
    /// **Best use cases:** TLS 1.3 cipher suite parity in custom protocols, encrypting data
    /// on low-power or older hardware without AES acceleration, and any context where
    /// software-only cryptography must remain constant-time.
    ///
    /// - Warning: Never reuse the same key + nonce pair. A fresh random nonce is generated
    ///   automatically on every call.
    ///
    /// - Parameters:
    ///   - data: The plaintext data to encrypt.
    ///   - key: A 256-bit symmetric key.
    /// - Returns: The sealed blob: `nonce || ciphertext || tag`.
    /// - Throws: `CryptoKitError` if the key size is not 256 bits.
    static public func chaChaPolyEncrypt(_ data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try ChaChaPoly.seal(data, using: key)
        return sealedBox.combined
    }

    /// Decrypts and authenticates a ChaCha20-Poly1305 sealed blob.
    ///
    /// Expects the blob produced by ``chaChaPolyEncrypt(_:using:)``:
    /// `nonce (12 bytes) || ciphertext || tag (16 bytes)`.
    ///
    /// Decryption fails with an `authenticationFailure` error if the ciphertext or tag has
    /// been tampered with.
    ///
    /// - Parameters:
    ///   - data: The sealed blob to decrypt.
    ///   - key: The same 256-bit symmetric key used during encryption.
    /// - Returns: The recovered plaintext.
    /// - Throws: `CryptoKitError.authenticationFailure` if authentication fails, or another
    ///   `CryptoKitError` if the data is malformed.
    static public func chaChaPolyDecrypt(_ data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        return try ChaChaPoly.open(sealedBox, using: key)
    }

    // MARK: - P-256 Signing (ECDSA)

    /// Generates a new P-256 ECDSA signing key pair.
    ///
    /// P-256 (also known as secp256r1 or prime256v1) is the most widely deployed elliptic
    /// curve in TLS, code signing, and certificate authorities. The private key is generated
    /// using the system's cryptographically secure random number generator.
    ///
    /// **Best use cases:** JWT signing (ES256), TLS client certificates, app attestation,
    /// and any interoperability scenario that requires P-256 compatibility.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateP256SigningKeyPair() -> (privateKey: P256.Signing.PrivateKey, publicKey: P256.Signing.PublicKey) {
        let privateKey = P256.Signing.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Signs data using ECDSA over P-256 and returns the signature in DER format.
    ///
    /// The data is hashed with SHA-256 internally before signing — do not pre-hash the input.
    /// The signature is returned in standard DER encoding, which is the format expected by
    /// most cryptographic protocols and libraries (e.g., OpenSSL, Security.framework).
    ///
    /// - Parameters:
    ///   - data: The data to sign. Hashed internally with SHA-256.
    ///   - privateKey: The P-256 private signing key.
    /// - Returns: The ECDSA signature in DER encoding.
    /// - Throws: `CryptoKitError` if signing fails.
    static public func p256Sign(_ data: Data, using privateKey: P256.Signing.PrivateKey) throws -> Data {
        try privateKey.signature(for: data).derRepresentation
    }

    /// Verifies a DER-encoded ECDSA P-256 signature against data and a public key.
    ///
    /// The data is hashed with SHA-256 internally — pass the original (unhashed) data,
    /// matching the input passed to ``p256Sign(_:using:)``.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature to verify.
    ///   - data: The original data that was signed.
    ///   - publicKey: The P-256 public key corresponding to the private key used for signing.
    /// - Returns: `true` if the signature is valid; `false` otherwise.
    static public func p256Verify(_ signature: Data, for data: Data, using publicKey: P256.Signing.PublicKey) -> Bool {
        guard let ecdsaSignature = try? P256.Signing.ECDSASignature(derRepresentation: signature) else { return false }
        return publicKey.isValidSignature(ecdsaSignature, for: data)
    }

    // MARK: - P-384 Signing (ECDSA)

    /// Generates a new P-384 ECDSA signing key pair.
    ///
    /// P-384 (secp384r1) provides a 192-bit security level — significantly stronger than
    /// P-256 — while remaining broadly supported. It is the curve of choice for NSA Suite B
    /// at the SECRET classification level and is commonly used in government and financial PKI.
    ///
    /// **Best use cases:** JWT signing (ES384), high-assurance document signing, certificate
    /// authorities issuing long-lived certificates, and compliance contexts requiring 192-bit
    /// equivalent security.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateP384SigningKeyPair() -> (privateKey: P384.Signing.PrivateKey, publicKey: P384.Signing.PublicKey) {
        let privateKey = P384.Signing.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Signs data using ECDSA over P-384 and returns the signature in DER format.
    ///
    /// The data is hashed with SHA-384 internally before signing — do not pre-hash the input.
    ///
    /// - Parameters:
    ///   - data: The data to sign. Hashed internally with SHA-384.
    ///   - privateKey: The P-384 private signing key.
    /// - Returns: The ECDSA signature in DER encoding.
    /// - Throws: `CryptoKitError` if signing fails.
    static public func p384Sign(_ data: Data, using privateKey: P384.Signing.PrivateKey) throws -> Data {
        try privateKey.signature(for: data).derRepresentation
    }

    /// Verifies a DER-encoded ECDSA P-384 signature against data and a public key.
    ///
    /// The data is hashed with SHA-384 internally — pass the original (unhashed) data.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature to verify.
    ///   - data: The original data that was signed.
    ///   - publicKey: The P-384 public key corresponding to the private key used for signing.
    /// - Returns: `true` if the signature is valid; `false` otherwise.
    static public func p384Verify(_ signature: Data, for data: Data, using publicKey: P384.Signing.PublicKey) -> Bool {
        guard let ecdsaSignature = try? P384.Signing.ECDSASignature(derRepresentation: signature) else { return false }
        return publicKey.isValidSignature(ecdsaSignature, for: data)
    }

    // MARK: - P-521 Signing (ECDSA)

    /// Generates a new P-521 ECDSA signing key pair.
    ///
    /// P-521 (secp521r1) offers a 260-bit security level — the highest of the three NIST
    /// prime curves — and is specified in NSA Suite B at the TOP SECRET classification level.
    /// Key generation and signing are slower than P-256/P-384 but the security margin is
    /// the largest available in CryptoKit's elliptic curve suite.
    ///
    /// **Best use cases:** JWT signing (ES512), root CA key material with multi-decade
    /// lifetimes, and any context where the highest possible ECDSA security margin is required
    /// regardless of performance cost.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateP521SigningKeyPair() -> (privateKey: P521.Signing.PrivateKey, publicKey: P521.Signing.PublicKey) {
        let privateKey = P521.Signing.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Signs data using ECDSA over P-521 and returns the signature in DER format.
    ///
    /// The data is hashed with SHA-512 internally before signing — do not pre-hash the input.
    ///
    /// - Parameters:
    ///   - data: The data to sign. Hashed internally with SHA-512.
    ///   - privateKey: The P-521 private signing key.
    /// - Returns: The ECDSA signature in DER encoding.
    /// - Throws: `CryptoKitError` if signing fails.
    static public func p521Sign(_ data: Data, using privateKey: P521.Signing.PrivateKey) throws -> Data {
        try privateKey.signature(for: data).derRepresentation
    }

    /// Verifies a DER-encoded ECDSA P-521 signature against data and a public key.
    ///
    /// The data is hashed with SHA-512 internally — pass the original (unhashed) data.
    ///
    /// - Parameters:
    ///   - signature: The DER-encoded ECDSA signature to verify.
    ///   - data: The original data that was signed.
    ///   - publicKey: The P-521 public key corresponding to the private key used for signing.
    /// - Returns: `true` if the signature is valid; `false` otherwise.
    static public func p521Verify(_ signature: Data, for data: Data, using publicKey: P521.Signing.PublicKey) -> Bool {
        guard let ecdsaSignature = try? P521.Signing.ECDSASignature(derRepresentation: signature) else { return false }
        return publicKey.isValidSignature(ecdsaSignature, for: data)
    }

    // MARK: - Ed25519 Signing (Curve25519)

    /// Generates a new Ed25519 signing key pair.
    ///
    /// Ed25519 is a modern EdDSA (Edwards-curve Digital Signature Algorithm) scheme built on
    /// Curve25519. It is designed to be fast, deterministic (no per-signature randomness),
    /// and resistant to side-channel attacks. Unlike ECDSA, it does not require a secure
    /// random number generator at signing time, eliminating an entire class of implementation
    /// vulnerabilities.
    ///
    /// **Best use cases:** SSH keys, JWT signing (EdDSA), API request authentication,
    /// software update signing, and any modern protocol where both performance and a clean
    /// security design are valued over legacy compatibility.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateEd25519SigningKeyPair() -> (privateKey: Curve25519.Signing.PrivateKey, publicKey: Curve25519.Signing.PublicKey) {
        let privateKey = Curve25519.Signing.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Signs data using Ed25519 and returns the 64-byte raw signature.
    ///
    /// Ed25519 hashes the data with SHA-512 internally as part of the EdDSA construction.
    /// Do not pre-hash the input. The signature is deterministic — signing the same data with
    /// the same key always produces the same output.
    ///
    /// - Parameters:
    ///   - data: The data to sign.
    ///   - privateKey: The Ed25519 private signing key.
    /// - Returns: The 64-byte raw Ed25519 signature.
    /// - Throws: `CryptoKitError` if signing fails.
    static public func ed25519Sign(_ data: Data, using privateKey: Curve25519.Signing.PrivateKey) throws -> Data {
        try privateKey.signature(for: data)
    }

    /// Verifies an Ed25519 signature against data and a public key.
    ///
    /// Pass the raw 64-byte signature produced by ``ed25519Sign(_:using:)`` and the original
    /// (unhashed) data.
    ///
    /// - Parameters:
    ///   - signature: The 64-byte raw Ed25519 signature.
    ///   - data: The original data that was signed.
    ///   - publicKey: The Ed25519 public key corresponding to the private key used for signing.
    /// - Returns: `true` if the signature is valid; `false` otherwise.
    static public func ed25519Verify(_ signature: Data, for data: Data, using publicKey: Curve25519.Signing.PublicKey) -> Bool {
        publicKey.isValidSignature(signature, for: data)
    }

    // MARK: - P-256 Key Agreement (ECDH)

    /// Generates a new P-256 key agreement key pair.
    ///
    /// Use the returned key pair with ``p256DeriveSymmetricKey(privateKey:peerPublicKey:salt:outputByteCount:)``
    /// to perform an ECDH key exchange and derive a shared symmetric key with a peer.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateP256KeyAgreementKeyPair() -> (privateKey: P256.KeyAgreement.PrivateKey, publicKey: P256.KeyAgreement.PublicKey) {
        let privateKey = P256.KeyAgreement.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Derives a shared symmetric key from a P-256 ECDH exchange using HKDF-SHA256.
    ///
    /// Performs an Elliptic Curve Diffie-Hellman (ECDH) key agreement between your private key
    /// and the peer's public key, then runs the shared secret through HKDF (RFC 5869) with
    /// SHA-256 to produce a uniformly random symmetric key. Both parties independently derive
    /// the same key without ever transmitting the secret over the wire.
    ///
    /// **Best use cases:** Establishing an encrypted session between two parties, hybrid
    /// encryption schemes (ECIES), and secure key exchange in custom protocols.
    ///
    /// - Parameters:
    ///   - privateKey: Your P-256 key agreement private key.
    ///   - peerPublicKey: The peer's P-256 key agreement public key.
    ///   - salt: Optional HKDF salt for domain separation. Defaults to empty data.
    ///   - outputByteCount: The desired output key length in bytes. Defaults to 32 (256 bits).
    /// - Returns: The derived ``SymmetricKey``.
    /// - Throws: `CryptoKitError` if key agreement fails (e.g. invalid peer public key).
    static public func p256DeriveSymmetricKey(
        privateKey: P256.KeyAgreement.PrivateKey,
        peerPublicKey: P256.KeyAgreement.PublicKey,
        salt: Data = Data(),
        outputByteCount: Int = 32
    ) throws -> SymmetricKey {
        let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: peerPublicKey)
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: salt, sharedInfo: Data(), outputByteCount: outputByteCount)
    }

    // MARK: - P-384 Key Agreement (ECDH)

    /// Generates a new P-384 key agreement key pair.
    ///
    /// Use the returned key pair with ``p384DeriveSymmetricKey(privateKey:peerPublicKey:salt:outputByteCount:)``
    /// to perform an ECDH key exchange and derive a shared symmetric key with a peer.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateP384KeyAgreementKeyPair() -> (privateKey: P384.KeyAgreement.PrivateKey, publicKey: P384.KeyAgreement.PublicKey) {
        let privateKey = P384.KeyAgreement.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Derives a shared symmetric key from a P-384 ECDH exchange using HKDF-SHA384.
    ///
    /// Performs ECDH over P-384, then derives a symmetric key via HKDF with SHA-384,
    /// maintaining a consistent 192-bit security level throughout the key derivation.
    ///
    /// **Best use cases:** High-assurance key exchange in financial or government protocols
    /// where the P-384 security level must be preserved end-to-end.
    ///
    /// - Parameters:
    ///   - privateKey: Your P-384 key agreement private key.
    ///   - peerPublicKey: The peer's P-384 key agreement public key.
    ///   - salt: Optional HKDF salt for domain separation. Defaults to empty data.
    ///   - outputByteCount: The desired output key length in bytes. Defaults to 32 (256 bits).
    /// - Returns: The derived ``SymmetricKey``.
    /// - Throws: `CryptoKitError` if key agreement fails.
    static public func p384DeriveSymmetricKey(
        privateKey: P384.KeyAgreement.PrivateKey,
        peerPublicKey: P384.KeyAgreement.PublicKey,
        salt: Data = Data(),
        outputByteCount: Int = 32
    ) throws -> SymmetricKey {
        let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: peerPublicKey)
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA384.self, salt: salt, sharedInfo: Data(), outputByteCount: outputByteCount)
    }

    // MARK: - P-521 Key Agreement (ECDH)

    /// Generates a new P-521 key agreement key pair.
    ///
    /// Use the returned key pair with ``p521DeriveSymmetricKey(privateKey:peerPublicKey:salt:outputByteCount:)``
    /// to perform an ECDH key exchange and derive a shared symmetric key with a peer.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateP521KeyAgreementKeyPair() -> (privateKey: P521.KeyAgreement.PrivateKey, publicKey: P521.KeyAgreement.PublicKey) {
        let privateKey = P521.KeyAgreement.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Derives a shared symmetric key from a P-521 ECDH exchange using HKDF-SHA512.
    ///
    /// Performs ECDH over P-521, then derives a symmetric key via HKDF with SHA-512.
    /// This combination provides the highest security level among the NIST prime curve
    /// key agreement options.
    ///
    /// **Best use cases:** Root-of-trust key establishment and protocols requiring
    /// maximum ECDH security regardless of performance cost.
    ///
    /// - Parameters:
    ///   - privateKey: Your P-521 key agreement private key.
    ///   - peerPublicKey: The peer's P-521 key agreement public key.
    ///   - salt: Optional HKDF salt for domain separation. Defaults to empty data.
    ///   - outputByteCount: The desired output key length in bytes. Defaults to 32 (256 bits).
    /// - Returns: The derived ``SymmetricKey``.
    /// - Throws: `CryptoKitError` if key agreement fails.
    static public func p521DeriveSymmetricKey(
        privateKey: P521.KeyAgreement.PrivateKey,
        peerPublicKey: P521.KeyAgreement.PublicKey,
        salt: Data = Data(),
        outputByteCount: Int = 32
    ) throws -> SymmetricKey {
        let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: peerPublicKey)
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA512.self, salt: salt, sharedInfo: Data(), outputByteCount: outputByteCount)
    }

    // MARK: - X25519 Key Agreement (Curve25519)

    /// Generates a new X25519 key agreement key pair.
    ///
    /// X25519 (Diffie-Hellman over Curve25519) is the modern, preferred key agreement
    /// algorithm, designed by Daniel J. Bernstein. It is faster than the NIST prime curves,
    /// immune to several classes of implementation mistakes, and is the standard key exchange
    /// algorithm in TLS 1.3, Signal Protocol, WireGuard, and Noise Protocol Framework.
    ///
    /// Use the returned key pair with ``x25519DeriveSymmetricKey(privateKey:peerPublicKey:salt:outputByteCount:)``
    /// to derive a shared symmetric key.
    ///
    /// - Returns: A tuple containing the private key and its derived public key.
    static public func generateX25519KeyAgreementKeyPair() -> (privateKey: Curve25519.KeyAgreement.PrivateKey, publicKey: Curve25519.KeyAgreement.PublicKey) {
        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        return (privateKey, privateKey.publicKey)
    }

    /// Derives a shared symmetric key from an X25519 ECDH exchange using HKDF-SHA256.
    ///
    /// Performs Diffie-Hellman over Curve25519, then derives a symmetric key via HKDF with
    /// SHA-256. This is the standard construction used in TLS 1.3 and most modern
    /// cryptographic protocols.
    ///
    /// **Best use cases:** End-to-end encrypted messaging, WireGuard-style tunnels, any
    /// modern protocol modelled on TLS 1.3 or the Noise Protocol Framework.
    ///
    /// - Parameters:
    ///   - privateKey: Your X25519 private key.
    ///   - peerPublicKey: The peer's X25519 public key.
    ///   - salt: Optional HKDF salt for domain separation. Defaults to empty data.
    ///   - outputByteCount: The desired output key length in bytes. Defaults to 32 (256 bits).
    /// - Returns: The derived ``SymmetricKey``.
    /// - Throws: `CryptoKitError` if key agreement fails.
    static public func x25519DeriveSymmetricKey(
        privateKey: Curve25519.KeyAgreement.PrivateKey,
        peerPublicKey: Curve25519.KeyAgreement.PublicKey,
        salt: Data = Data(),
        outputByteCount: Int = 32
    ) throws -> SymmetricKey {
        let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: peerPublicKey)
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: salt, sharedInfo: Data(), outputByteCount: outputByteCount)
    }
}
