import CryptoKit
import Foundation
@testable import EssentialKit
import XCTest

final class FileManagerCryptoTests: XCTestCase {
    private let fm = FileManager.default
    private var tempDir: URL!
    private let content = "The quick brown fox jumps over the lazy dog"

    override func setUp() {
        super.setUp()
        tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() {
        try? fm.removeItem(at: tempDir)
        super.tearDown()
    }

    // MARK: - Helpers

    private func writeTempFile(name: String, content: String) throws -> URL {
        let url = tempDir.appendingPathComponent(name)
        try Data(content.utf8).write(to: url)
        return url
    }

    private func tempURL(_ name: String) -> URL {
        tempDir.appendingPathComponent(name)
    }

    // MARK: - File Hashing

    func testFileSha256MatchesDataSha256() throws {
        let url = try writeTempFile(name: "input.txt", content: content)
        let fileHash = try fm.sha256(at: url)
        let dataHash = Data(content.utf8).sha256
        XCTAssertEqual(fileHash, dataHash)
    }

    func testFileSha384MatchesDataSha384() throws {
        let url = try writeTempFile(name: "input.txt", content: content)
        let fileHash = try fm.sha384(at: url)
        let dataHash = Data(content.utf8).sha384
        XCTAssertEqual(fileHash, dataHash)
    }

    func testFileSha512MatchesDataSha512() throws {
        let url = try writeTempFile(name: "input.txt", content: content)
        let fileHash = try fm.sha512(at: url)
        let dataHash = Data(content.utf8).sha512
        XCTAssertEqual(fileHash, dataHash)
    }

    func testFileHashChangesWhenContentChanges() throws {
        let url = try writeTempFile(name: "input.txt", content: content)
        let hashBefore = try fm.sha256(at: url)
        try Data("modified content".utf8).write(to: url)
        let hashAfter = try fm.sha256(at: url)
        XCTAssertNotEqual(hashBefore, hashAfter)
    }

    func testFileHashThrowsForMissingFile() {
        XCTAssertThrowsError(try fm.sha256(at: tempURL("nonexistent.txt")))
    }

    // MARK: - SHA-3 File Hashing

    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func testFileSha3_256MatchesDataSha3_256() throws {
        let url = try writeTempFile(name: "input.txt", content: content)
        let fileHash = try fm.sha3_256(at: url)
        let dataHash = Data(content.utf8).sha3_256
        XCTAssertEqual(fileHash, dataHash)
    }

    @available(iOS 26, macOS 26, watchOS 26, tvOS 26, *)
    func testFileSha3_512MatchesDataSha3_512() throws {
        let url = try writeTempFile(name: "input.txt", content: content)
        let fileHash = try fm.sha3_512(at: url)
        let dataHash = Data(content.utf8).sha3_512
        XCTAssertEqual(fileHash, dataHash)
    }

    // MARK: - AES-GCM File Encryption

    func testAESGCMFileRoundtrip() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let decryptedURL = tempURL("decrypted.txt")
        let key = Crypto.generateSymmetricKey()

        try fm.aesGCMEncrypt(at: sourceURL, to: encryptedURL, using: key)
        try fm.aesGCMDecrypt(at: encryptedURL, to: decryptedURL, using: key)

        let recovered = try String(data: Data(contentsOf: decryptedURL), encoding: .utf8)
        XCTAssertEqual(recovered, content)
    }

    func testAESGCMEncryptedFileIsLargerThanPlaintext() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let key = Crypto.generateSymmetricKey()

        try fm.aesGCMEncrypt(at: sourceURL, to: encryptedURL, using: key)

        let originalSize = try Data(contentsOf: sourceURL).count
        let encryptedSize = try Data(contentsOf: encryptedURL).count
        // Overhead is exactly 28 bytes: 12-byte nonce + 16-byte tag
        XCTAssertEqual(encryptedSize, originalSize + 28)
    }

    func testAESGCMFileDecryptionFailsWithWrongKey() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let decryptedURL = tempURL("decrypted.txt")

        try fm.aesGCMEncrypt(at: sourceURL, to: encryptedURL, using: Crypto.generateSymmetricKey())
        XCTAssertThrowsError(try fm.aesGCMDecrypt(at: encryptedURL, to: decryptedURL, using: Crypto.generateSymmetricKey()))
    }

    func testAESGCMFileDecryptionFailsAfterTampering() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let decryptedURL = tempURL("decrypted.txt")
        let key = Crypto.generateSymmetricKey()

        try fm.aesGCMEncrypt(at: sourceURL, to: encryptedURL, using: key)

        var encryptedBytes = try Data(contentsOf: encryptedURL)
        encryptedBytes[20] ^= 0xFF
        try encryptedBytes.write(to: encryptedURL)

        XCTAssertThrowsError(try fm.aesGCMDecrypt(at: encryptedURL, to: decryptedURL, using: key))
    }

    // MARK: - ChaCha20-Poly1305 File Encryption

    func testChaChaPolyFileRoundtrip() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let decryptedURL = tempURL("decrypted.txt")
        let key = Crypto.generateSymmetricKey()

        try fm.chaChaPolyEncrypt(at: sourceURL, to: encryptedURL, using: key)
        try fm.chaChaPolyDecrypt(at: encryptedURL, to: decryptedURL, using: key)

        let recovered = try String(data: Data(contentsOf: decryptedURL), encoding: .utf8)
        XCTAssertEqual(recovered, content)
    }

    func testChaChaPolyEncryptedFileIsLargerThanPlaintext() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let key = Crypto.generateSymmetricKey()

        try fm.chaChaPolyEncrypt(at: sourceURL, to: encryptedURL, using: key)

        let originalSize = try Data(contentsOf: sourceURL).count
        let encryptedSize = try Data(contentsOf: encryptedURL).count
        XCTAssertEqual(encryptedSize, originalSize + 28)
    }

    func testChaChaPolyFileDecryptionFailsWithWrongKey() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let decryptedURL = tempURL("decrypted.txt")

        try fm.chaChaPolyEncrypt(at: sourceURL, to: encryptedURL, using: Crypto.generateSymmetricKey())
        XCTAssertThrowsError(try fm.chaChaPolyDecrypt(at: encryptedURL, to: decryptedURL, using: Crypto.generateSymmetricKey()))
    }

    func testChaChaPolyFileDecryptionFailsAfterTampering() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let decryptedURL = tempURL("decrypted.txt")
        let key = Crypto.generateSymmetricKey()

        try fm.chaChaPolyEncrypt(at: sourceURL, to: encryptedURL, using: key)

        var encryptedBytes = try Data(contentsOf: encryptedURL)
        encryptedBytes[20] ^= 0xFF
        try encryptedBytes.write(to: encryptedURL)

        XCTAssertThrowsError(try fm.chaChaPolyDecrypt(at: encryptedURL, to: decryptedURL, using: key))
    }

    func testAESGCMAndChaChaPolyOutputAreNotInterchangeable() throws {
        let sourceURL = try writeTempFile(name: "plaintext.txt", content: content)
        let encryptedURL = tempURL("encrypted.bin")
        let decryptedURL = tempURL("decrypted.txt")
        let key = Crypto.generateSymmetricKey()

        try fm.aesGCMEncrypt(at: sourceURL, to: encryptedURL, using: key)
        XCTAssertThrowsError(try fm.chaChaPolyDecrypt(at: encryptedURL, to: decryptedURL, using: key))
    }
}
