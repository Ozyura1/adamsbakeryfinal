<?php
include 'backend/db.php';

if (isset($_GET['email']) && isset($_GET['transaction_id'])) {
    $email = $conn->real_escape_string($_GET['email']);
    $transaction_id = $conn->real_escape_string($_GET['transaction_id']);
    
    $result = $conn->query("SELECT * FROM transactions WHERE id = '$transaction_id' AND email = '$email' AND status = 'confirmed'");
    
    if ($result->num_rows > 0) {
        header("Location: review.php?transaction_id=" . $transaction_id);
        exit();
    } else {
        $error = "Transaksi tidak ditemukan atau belum dikonfirmasi.";
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Cek Status Ulasan - Adam Bakery</title>
    <link rel="stylesheet" href="css/style.css">
<<<<<<< HEAD
    <link rel="icon" type="image/png" href="../assets/logoadambakery.png">
=======
>>>>>>> 5163a4946f68ea1915a84c755a0899aa86013e39
</head>
<body>
<?php include 'includes/header.php'; ?>

<main>
    <h2>Beri Status Ulasan</h2>
    
    <?php if (isset($error)): ?>
        <div class="alert alert-error"><?php echo $error; ?></div>
    <?php endif; ?>
    
    <form method="get">
        <p>Masukkan email dan ID transaksi untuk memberikan ulasan:</p>
        
        <label>Email:</label>
        <input type="email" name="email" required>
        
        <label>ID Transaksi:</label>
        <input type="text" name="transaction_id" required>
        
        <button type="submit">Cek Status</button>
    </form>
    
    <div class="text-center mt-2">
        <a href="index.php" class="btn">Kembali ke Beranda</a>
    </div>
</main>

<?php include 'includes/footer.php'; ?>
