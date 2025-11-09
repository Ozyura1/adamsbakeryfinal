<?php
session_start();
include 'db.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nama_pembeli = $conn->real_escape_string($_POST['nama_pembeli']);
    $email = $conn->real_escape_string($_POST['email']);
    $phone = $conn->real_escape_string($_POST['phone']);
    $alamat = $conn->real_escape_string($_POST['alamat']);
    $total_amount = $conn->real_escape_string($_POST['total_amount']);
    $account_name = $conn->real_escape_string($_POST['account_name']);
    $account_number = $conn->real_escape_string($_POST['account_number']);
    $bank_name = $conn->real_escape_string($_POST['bank_name']);
    $transfer_amount = $conn->real_escape_string($_POST['transfer_amount']);
    $customer_id = isset($_POST['customer_id']) ? $conn->real_escape_string($_POST['customer_id']) : null;

    // === Handle file upload ===
    $bukti_pembayaran = null;
    if (isset($_FILES['transfer_proof']) && $_FILES['transfer_proof']['error'] == 0) {
        // Pastikan folder upload ada
        $uploadDir = '../uploads/bukti_pembayaran/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        // Buat nama file unik
        $fileExt = pathinfo($_FILES['transfer_proof']['name'], PATHINFO_EXTENSION);
        $fileName = 'bukti_' . time() . '.' . $fileExt;
        $filePath = $uploadDir . $fileName;

        // Pindahkan file ke folder tujuan
        if (move_uploaded_file($_FILES['transfer_proof']['tmp_name'], $filePath)) {
            $bukti_pembayaran = $fileName;
        }
    }

    // === Simpan transaksi ke database ===
    $sql = "INSERT INTO transactions 
            (customer_id, nama_pembeli, email, phone, alamat, total_amount, bank_name, account_name, account_number, transfer_amount, bukti_pembayaran, status) 
            VALUES (
                '$customer_id', '$nama_pembeli', '$email', '$phone', '$alamat', 
                '$total_amount', '$bank_name', '$account_name', '$account_number', 
                '$transfer_amount', " . 
                ($bukti_pembayaran ? "'$bukti_pembayaran'" : "NULL") . ", 
                'pending'
            )";

    if ($conn->query($sql)) {
        $transaction_id = $conn->insert_id;

        // === Insert transaction items ===
        if (isset($_SESSION['cart'])) {
            foreach ($_SESSION['cart'] as $item) {
                $item_type = $item['type'];
                $item_id = $item['id'];
                $quantity = $item['quantity'];

                if ($item_type == 'product') {
                    $result = $conn->query("SELECT harga FROM products WHERE id = $item_id");
                    $price = $result->fetch_assoc()['harga'];
                    $sql_item = "INSERT INTO transaction_items (transaction_id, product_id, item_type, quantity, price)
                                 VALUES ('$transaction_id', '$item_id', 'product', '$quantity', '$price')";
                } else {
                    $result = $conn->query("SELECT harga FROM packages WHERE id = $item_id");
                    $price = $result->fetch_assoc()['harga'];
                    $sql_item = "INSERT INTO transaction_items (transaction_id, package_id, item_type, quantity, price)
                                 VALUES ('$transaction_id', '$item_id', 'package', '$quantity', '$price')";
                }

                $conn->query($sql_item);
            }
        }

        // === Kosongkan keranjang ===
        $_SESSION['cart'] = [];

        // === Redirect ke halaman sukses ===
        header("Location: ../payment_success.php?transaction_id=" . $transaction_id);
        exit();
    } else {
        echo "Error: " . $conn->error;
    }
} else {
    header("Location: ../checkout.php");
    exit();
}
?>
