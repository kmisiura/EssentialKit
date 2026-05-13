import CryptoKit
import Foundation
@testable import EssentialKit
import XCTest

final class CryptoTests: XCTestCase {
    private let input = "The quick brown fox jumps over the lazy dog"
    private var inputData: Data { Data(input.utf8) }

    // MARK: - SHA-2

    func testSha256() {
        let expected = "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"
        XCTAssertEqual(Crypto.sha256(input), expected)
        XCTAssertEqual(input.sha256, expected)
        XCTAssertEqual(Data(input.utf8).sha256, expected)
    }

    func testSha384() {
        let expected = "ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1"
        XCTAssertEqual(Crypto.sha384(input), expected)
        XCTAssertEqual(input.sha384, expected)
        XCTAssertEqual(Data(input.utf8).sha384, expected)
    }

    func testSha512() {
        let expected = "07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6"
        XCTAssertEqual(Crypto.sha512(input), expected)
        XCTAssertEqual(input.sha512, expected)
        XCTAssertEqual(Data(input.utf8).sha512, expected)
    }

    // MARK: - SHA-3

    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func testSha3_256() {
        let expected = "69070dda01975c8c120c3aada1b282394e7f032fa9cf32f4cb2259a0897dfc04"
        XCTAssertEqual(Crypto.sha3_256(input), expected)
        XCTAssertEqual(input.sha3_256, expected)
        XCTAssertEqual(Data(input.utf8).sha3_256, expected)
    }

    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func testSha3_384() {
        let expected = "7063465e08a93bce31cd89d2e3ca8f602498696e253592ed26f07bf7e703cf328581e1471a7ba7ab119b1a9ebdf8be41"
        XCTAssertEqual(Crypto.sha3_384(input), expected)
        XCTAssertEqual(input.sha3_384, expected)
        XCTAssertEqual(Data(input.utf8).sha3_384, expected)
    }

    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func testSha3_512() {
        let expected = "01dedd5de4ef14642445ba5f5b97c15e47b9ad931326e4b0727cd94cefc44fff23f07bf543139939b49128caf436dc1bdee54fcb24023a08d9403f9b4bf0d450"
        XCTAssertEqual(Crypto.sha3_512(input), expected)
        XCTAssertEqual(input.sha3_512, expected)
        XCTAssertEqual(Data(input.utf8).sha3_512, expected)
    }

    // MARK: - Symmetric Key Generation

    func testSymmetricKeyGeneration() {
        let key128 = Crypto.generateSymmetricKey(size: .bits128)
        let key192 = Crypto.generateSymmetricKey(size: .bits192)
        let key256 = Crypto.generateSymmetricKey(size: .bits256)
        XCTAssertEqual(key128.bitCount, 128)
        XCTAssertEqual(key192.bitCount, 192)
        XCTAssertEqual(key256.bitCount, 256)
        // Two generated keys must not be equal
        let key256b = Crypto.generateSymmetricKey()
        XCTAssertNotEqual(key256.rawBytes, key256b.rawBytes)
    }

    // MARK: - AES-GCM

    func testAESGCMRoundtrip() throws {
        let key = Crypto.generateSymmetricKey()
        let encrypted = try Crypto.aesGCMEncrypt(inputData, using: key)
        let decrypted = try Crypto.aesGCMDecrypt(encrypted, using: key)
        XCTAssertEqual(decrypted, inputData)
        // Verify minimum overhead: 12-byte nonce + 16-byte tag
        XCTAssertEqual(encrypted.count, inputData.count + 28)
    }

    func testAESGCMRoundtripViaExtensions() throws {
        let key = Crypto.generateSymmetricKey()
        let encryptedFromData = try inputData.aesGCMEncrypted(using: key)
        let decryptedFromData = try encryptedFromData.aesGCMDecrypted(using: key)
        XCTAssertEqual(decryptedFromData, inputData)

        let encryptedFromString = try input.aesGCMEncrypted(using: key)
        let decryptedFromString = try encryptedFromString.aesGCMDecrypted(using: key)
        XCTAssertEqual(decryptedFromString, inputData)
    }

    func testAESGCMTamperDetection() throws {
        let key = Crypto.generateSymmetricKey()
        var encrypted = try Crypto.aesGCMEncrypt(inputData, using: key)
        encrypted[20] ^= 0xFF
        XCTAssertThrowsError(try Crypto.aesGCMDecrypt(encrypted, using: key))
    }

    func testAESGCMWrongKeyFails() throws {
        let key = Crypto.generateSymmetricKey()
        let encrypted = try Crypto.aesGCMEncrypt(inputData, using: key)
        let wrongKey = Crypto.generateSymmetricKey()
        XCTAssertThrowsError(try Crypto.aesGCMDecrypt(encrypted, using: wrongKey))
    }

    // MARK: - ChaCha20-Poly1305

    func testChaChaPolyRoundtrip() throws {
        let key = Crypto.generateSymmetricKey()
        let encrypted = try Crypto.chaChaPolyEncrypt(inputData, using: key)
        let decrypted = try Crypto.chaChaPolyDecrypt(encrypted, using: key)
        XCTAssertEqual(decrypted, inputData)
        XCTAssertEqual(encrypted.count, inputData.count + 28)
    }

    func testChaChaPolyRoundtripViaExtensions() throws {
        let key = Crypto.generateSymmetricKey()
        let encryptedFromData = try inputData.chaChaPolyEncrypted(using: key)
        let decryptedFromData = try encryptedFromData.chaChaPolyDecrypted(using: key)
        XCTAssertEqual(decryptedFromData, inputData)

        let encryptedFromString = try input.chaChaPolyEncrypted(using: key)
        let decryptedFromString = try encryptedFromString.chaChaPolyDecrypted(using: key)
        XCTAssertEqual(decryptedFromString, inputData)
    }

    func testChaChaPolyTamperDetection() throws {
        let key = Crypto.generateSymmetricKey()
        var encrypted = try Crypto.chaChaPolyEncrypt(inputData, using: key)
        encrypted[20] ^= 0xFF
        XCTAssertThrowsError(try Crypto.chaChaPolyDecrypt(encrypted, using: key))
    }

    func testChaChaPolyWrongKeyFails() throws {
        let key = Crypto.generateSymmetricKey()
        let encrypted = try Crypto.chaChaPolyEncrypt(inputData, using: key)
        let wrongKey = Crypto.generateSymmetricKey()
        XCTAssertThrowsError(try Crypto.chaChaPolyDecrypt(encrypted, using: wrongKey))
    }

    // MARK: - P-256 Signing

    func testP256SigningRoundtrip() throws {
        let (privateKey, publicKey) = Crypto.generateP256SigningKeyPair()
        let signature = try Crypto.p256Sign(inputData, using: privateKey)
        XCTAssertTrue(Crypto.p256Verify(signature, for: inputData, using: publicKey))
    }

    func testP256SigningViaExtensions() throws {
        let (privateKey, publicKey) = Crypto.generateP256SigningKeyPair()
        let sig = try inputData.p256Signed(using: privateKey)
        XCTAssertTrue(inputData.p256VerifySignature(sig, using: publicKey))
        let sigFromString = try input.p256Signed(using: privateKey)
        XCTAssertTrue(input.p256VerifySignature(sigFromString, using: publicKey))
    }

    func testP256SigningRejectsInvalidSignature() throws {
        let (privateKey, publicKey) = Crypto.generateP256SigningKeyPair()
        var signature = try Crypto.p256Sign(inputData, using: privateKey)
        signature[10] ^= 0xFF
        XCTAssertFalse(Crypto.p256Verify(signature, for: inputData, using: publicKey))
    }

    func testP256SigningRejectsWrongData() throws {
        let (privateKey, publicKey) = Crypto.generateP256SigningKeyPair()
        let signature = try Crypto.p256Sign(inputData, using: privateKey)
        let otherData = Data("different message".utf8)
        XCTAssertFalse(Crypto.p256Verify(signature, for: otherData, using: publicKey))
    }

    // MARK: - P-384 Signing

    func testP384SigningRoundtrip() throws {
        let (privateKey, publicKey) = Crypto.generateP384SigningKeyPair()
        let signature = try Crypto.p384Sign(inputData, using: privateKey)
        XCTAssertTrue(Crypto.p384Verify(signature, for: inputData, using: publicKey))
    }

    func testP384SigningViaExtensions() throws {
        let (privateKey, publicKey) = Crypto.generateP384SigningKeyPair()
        let sig = try inputData.p384Signed(using: privateKey)
        XCTAssertTrue(inputData.p384VerifySignature(sig, using: publicKey))
        let sigFromString = try input.p384Signed(using: privateKey)
        XCTAssertTrue(input.p384VerifySignature(sigFromString, using: publicKey))
    }

    func testP384SigningRejectsInvalidSignature() throws {
        let (privateKey, publicKey) = Crypto.generateP384SigningKeyPair()
        var signature = try Crypto.p384Sign(inputData, using: privateKey)
        signature[10] ^= 0xFF
        XCTAssertFalse(Crypto.p384Verify(signature, for: inputData, using: publicKey))
    }

    // MARK: - P-521 Signing

    func testP521SigningRoundtrip() throws {
        let (privateKey, publicKey) = Crypto.generateP521SigningKeyPair()
        let signature = try Crypto.p521Sign(inputData, using: privateKey)
        XCTAssertTrue(Crypto.p521Verify(signature, for: inputData, using: publicKey))
    }

    func testP521SigningViaExtensions() throws {
        let (privateKey, publicKey) = Crypto.generateP521SigningKeyPair()
        let sig = try inputData.p521Signed(using: privateKey)
        XCTAssertTrue(inputData.p521VerifySignature(sig, using: publicKey))
        let sigFromString = try input.p521Signed(using: privateKey)
        XCTAssertTrue(input.p521VerifySignature(sigFromString, using: publicKey))
    }

    func testP521SigningRejectsInvalidSignature() throws {
        let (privateKey, publicKey) = Crypto.generateP521SigningKeyPair()
        var signature = try Crypto.p521Sign(inputData, using: privateKey)
        signature[10] ^= 0xFF
        XCTAssertFalse(Crypto.p521Verify(signature, for: inputData, using: publicKey))
    }

    // MARK: - Ed25519 Signing

    func testEd25519SigningRoundtrip() throws {
        let (privateKey, publicKey) = Crypto.generateEd25519SigningKeyPair()
        let signature = try Crypto.ed25519Sign(inputData, using: privateKey)
        XCTAssertTrue(Crypto.ed25519Verify(signature, for: inputData, using: publicKey))
        // CryptoKit uses randomized (hedged) Ed25519 to guard against side-channel attacks,
        // so signatures are not byte-equal across calls — but both must verify correctly.
        let signatureAgain = try Crypto.ed25519Sign(inputData, using: privateKey)
        XCTAssertTrue(Crypto.ed25519Verify(signatureAgain, for: inputData, using: publicKey))
    }

    func testEd25519SigningViaExtensions() throws {
        let (privateKey, publicKey) = Crypto.generateEd25519SigningKeyPair()
        let sig = try inputData.ed25519Signed(using: privateKey)
        XCTAssertTrue(inputData.ed25519VerifySignature(sig, using: publicKey))
        let sigFromString = try input.ed25519Signed(using: privateKey)
        XCTAssertTrue(input.ed25519VerifySignature(sigFromString, using: publicKey))
    }

    func testEd25519SigningRejectsWrongData() throws {
        let (privateKey, publicKey) = Crypto.generateEd25519SigningKeyPair()
        let signature = try Crypto.ed25519Sign(inputData, using: privateKey)
        let otherData = Data("different message".utf8)
        XCTAssertFalse(Crypto.ed25519Verify(signature, for: otherData, using: publicKey))
    }

    // MARK: - P-256 Key Agreement

    func testP256KeyAgreement() throws {
        let (alicePrivate, alicePublic) = Crypto.generateP256KeyAgreementKeyPair()
        let (bobPrivate, bobPublic) = Crypto.generateP256KeyAgreementKeyPair()
        let aliceKey = try Crypto.p256DeriveSymmetricKey(privateKey: alicePrivate, peerPublicKey: bobPublic)
        let bobKey = try Crypto.p256DeriveSymmetricKey(privateKey: bobPrivate, peerPublicKey: alicePublic)
        XCTAssertEqual(aliceKey.rawBytes, bobKey.rawBytes)
        XCTAssertEqual(aliceKey.bitCount, 256)
    }

    func testP256KeyAgreementWithSalt() throws {
        let salt = Data("channel-identifier".utf8)
        let (alicePrivate, alicePublic) = Crypto.generateP256KeyAgreementKeyPair()
        let (bobPrivate, bobPublic) = Crypto.generateP256KeyAgreementKeyPair()
        let aliceKey = try Crypto.p256DeriveSymmetricKey(privateKey: alicePrivate, peerPublicKey: bobPublic, salt: salt)
        let bobKey = try Crypto.p256DeriveSymmetricKey(privateKey: bobPrivate, peerPublicKey: alicePublic, salt: salt)
        XCTAssertEqual(aliceKey.rawBytes, bobKey.rawBytes)
        // Different salt must produce a different key
        let differentSaltKey = try Crypto.p256DeriveSymmetricKey(privateKey: alicePrivate, peerPublicKey: bobPublic, salt: Data("other".utf8))
        XCTAssertNotEqual(aliceKey.rawBytes, differentSaltKey.rawBytes)
    }

    // MARK: - P-384 Key Agreement

    func testP384KeyAgreement() throws {
        let (alicePrivate, alicePublic) = Crypto.generateP384KeyAgreementKeyPair()
        let (bobPrivate, bobPublic) = Crypto.generateP384KeyAgreementKeyPair()
        let aliceKey = try Crypto.p384DeriveSymmetricKey(privateKey: alicePrivate, peerPublicKey: bobPublic)
        let bobKey = try Crypto.p384DeriveSymmetricKey(privateKey: bobPrivate, peerPublicKey: alicePublic)
        XCTAssertEqual(aliceKey.rawBytes, bobKey.rawBytes)
    }

    // MARK: - P-521 Key Agreement

    func testP521KeyAgreement() throws {
        let (alicePrivate, alicePublic) = Crypto.generateP521KeyAgreementKeyPair()
        let (bobPrivate, bobPublic) = Crypto.generateP521KeyAgreementKeyPair()
        let aliceKey = try Crypto.p521DeriveSymmetricKey(privateKey: alicePrivate, peerPublicKey: bobPublic)
        let bobKey = try Crypto.p521DeriveSymmetricKey(privateKey: bobPrivate, peerPublicKey: alicePublic)
        XCTAssertEqual(aliceKey.rawBytes, bobKey.rawBytes)
    }

    // MARK: - X25519 Key Agreement

    func testX25519KeyAgreement() throws {
        let (alicePrivate, alicePublic) = Crypto.generateX25519KeyAgreementKeyPair()
        let (bobPrivate, bobPublic) = Crypto.generateX25519KeyAgreementKeyPair()
        let aliceKey = try Crypto.x25519DeriveSymmetricKey(privateKey: alicePrivate, peerPublicKey: bobPublic)
        let bobKey = try Crypto.x25519DeriveSymmetricKey(privateKey: bobPrivate, peerPublicKey: alicePublic)
        XCTAssertEqual(aliceKey.rawBytes, bobKey.rawBytes)
        XCTAssertEqual(aliceKey.bitCount, 256)
    }
}

// MARK: - Helpers

private extension SymmetricKey {
    var rawBytes: Data { withUnsafeBytes { Data($0) } }
}
