<?php 
include 'includes/header.php';
include 'backend/db.php';
session_start();

if (!isset($_SESSION['customer_id'])) {
    $_SESSION['redirect_after_login'] = 'checkout.php';
    header("Location: customer_auth.php");
    exit();
}

if (!isset($_SESSION['cart'])) $_SESSION['cart'] = [];

// === Jika user membuka transaksi lama ===
if (isset($_GET['transaction_id']) || isset($_GET['order_id'])) {
    $transaction_id = isset($_GET['transaction_id']) 
        ? intval($_GET['transaction_id']) 
        : intval($_GET['order_id']);
    $query = "SELECT * FROM transactions WHERE id = $transaction_id AND customer_id = " . $_SESSION['customer_id'];
    $result = $conn->query($query);

    if ($result && $result->num_rows > 0) {
        $transaction = $result->fetch_assoc();
        $show_checkout_form = false;

        // Ambil item dari tabel transaction_items
        $items_q = $conn->query("SELECT * FROM transaction_items WHERE transaction_id = $transaction_id");
        $cart_items = [];
        $cart_total = 0;

        while ($item = $items_q->fetch_assoc()) {
            // ✅ Tentukan tabel dan ID yang benar sesuai jenis item
            if ($item['item_type'] === 'product') {
                $table = 'products';
                $item_id = $item['product_id'];
            } else {
                $table = 'packages';
                $item_id = $item['package_id'];
            }

            // ✅ Hindari error kalau kolom ID kosong
            if (empty($item_id)) continue;

            // Ambil detail item
            $prod_q = $conn->query("SELECT nama, harga FROM $table WHERE id = $item_id");
            if ($prod_q && $prod_q->num_rows > 0) {
                $prod = $prod_q->fetch_assoc();
                $subtotal = $prod['harga'] * $item['quantity'];
                $cart_items[] = [
                    'name' => $prod['nama'],
                    'price' => $prod['harga'],
                    'quantity' => $item['quantity'],
                    'subtotal' => $subtotal,
                    'type' => $item['item_type']
                ];
                $cart_total += $subtotal;
            }
        }
    } else {
        $cart_items = [];
    }
}


// === Handle tambah ke keranjang ===
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['add_to_cart'])) {
    $item_type = $_POST['item_type'];
    $item_id = $_POST['item_id'];
    $quantity = $_POST['quantity'];
    $cart_key = $item_type . '_' . $item_id;
    
    if (isset($_SESSION['cart'][$cart_key])) {
        $_SESSION['cart'][$cart_key]['quantity'] += $quantity;
    } else {
        $_SESSION['cart'][$cart_key] = [
            'type' => $item_type,
            'id' => $item_id,
            'quantity' => $quantity
        ];
    }
    header("Location: checkout.php?added=true");
    exit();
}

// === Handle hapus item ===
if (isset($_GET['remove'])) {
    unset($_SESSION['cart'][$_GET['remove']]);
    $success = "Item berhasil dihapus dari keranjang!";
}

// === Handle update keranjang ===
$show_checkout_form = false;
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['update_cart'])) {
    foreach ($_POST['quantities'] as $key => $qty) {
        $qty = (int)$qty;
        if ($qty > 0) $_SESSION['cart'][$key]['quantity'] = $qty;
        else unset($_SESSION['cart'][$key]);
    }
    $success = "Keranjang berhasil diperbarui!";
    $show_checkout_form = true;
}

// === Hitung total keranjang ===
$cart_total = 0;
$cart_items = [];
foreach ($_SESSION['cart'] as $key => $item) {
    $table = $item['type'] == 'product' ? 'products' : 'packages';
    $result = $conn->query("SELECT * FROM $table WHERE id = " . $item['id']);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $cart_items[$key] = [
            'name' => $row['nama'],
            'price' => $row['harga'],
            'quantity' => $item['quantity'],
            'type' => $item['type'],
            'subtotal' => $row['harga'] * $item['quantity']
        ];
        $cart_total += $cart_items[$key]['subtotal'];
    }
}

// === Ambil data customer ===
$customer_sql = "SELECT * FROM customer_users WHERE id = " . $_SESSION['customer_id'];
$customer_data = $conn->query($customer_sql)->fetch_assoc();
?>


<style>
main {
  background-color: #f6e5c8;
  border-radius: 20px;
  padding: 2.5rem;
  position: relative;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.header-top {
  background-color: #fff8e7;
  border: 1px solid #f0e0c0;
  border-radius: 12px;
  padding: 2rem 1.5rem;
  text-align: center;
  margin-bottom: 2rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.header-right {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

.header-right span {
  color: #5c4a34;
  font-size: 1rem;
  font-weight: 500;
}

.header-right a.btn-secondary {
  background: linear-gradient(135deg, #f4e4c1, #e8d5b7);
  color: #8b5a3c;
  font-weight: 600;
  border-radius: 25px;
  padding: 0.4rem 1rem;
  text-decoration: none;
  transition: 0.3s;
}

.header-right a.btn-secondary:hover {
  background: linear-gradient(135deg, #f1dab2, #e0cba5);
}

main a.btn, button.btn {
  background-color: #8b5a3c;
  color: #fff;
  border: none;
  padding: 0.8rem 2rem;
  border-radius: 25px;
  cursor: pointer;
  display: block;
  margin: 1rem auto;
  text-align: center;
  text-decoration: none;
  transition: 0.3s;
}

button.btn:hover, main a.btn:hover {
  background-color: #70492f;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 2rem;
}
table th, table td {
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #ddd;
}
table th {
  background-color: #f4e4c1;
  color: #5c3b20;
}

.alert-success {
  background: #fff9e6;
  color: #7a5b2b;
  padding: 0.75rem;
  text-align: center;
  border-radius: 8px;
  border: 1px solid #f0e0b0;
  margin-bottom: 1rem;
}

/* ========================= */
/* 📱 Responsive Design Area */
/* ========================= */

/* Tablet */
@media (max-width: 992px) {
  main {
    padding: 2rem;
  }

  .header-top {
    padding: 1.5rem 1rem;
  }

  table th, table td {
    padding: 0.6rem 0.8rem;
  }
}

/* Mobile Landscape (<= 768px) */
@media (max-width: 768px) {
  main {
    padding: 1.5rem;
    border-radius: 15px;
  }

  .header-right {
    flex-direction: column;
    text-align: center;
  }

  .header-right span {
    font-size: 0.95rem;
  }

  main a.btn, button.btn {
    width: 100%;
    padding: 0.9rem;
  }

  table {
    font-size: 0.9rem;
  }

  table th, table td {
    padding: 0.6rem 0.7rem;
  }
}

/* Mobile Portrait (<= 480px) */
@media (max-width: 480px) {
  main {
    padding: 1rem;
    border-radius: 12px;
  }

  .header-top {
    padding: 1rem;
    margin-bottom: 1.5rem;
  }

  .header-right {
    gap: 0.5rem;
  }

  .header-right a.btn-secondary {
    width: 100%;
    text-align: center;
  }

  table th, table td {
    padding: 0.5rem;
  }

  table {
    display: block;
    overflow-x: auto;
    white-space: nowrap;
  }

  .alert-success {
    font-size: 0.9rem;
  }
}


</style>


<main>
  <?php if (isset($success)): ?>
    <div class="alert-success"><?= $success ?></div>
  <?php endif; ?>

  <?php if (empty($cart_items)): ?>
    <div class="header-top"><h2>Keranjang Belanja</h2></div>
    <div class="header-right">
        <span>Selamat datang, <?= $_SESSION['customer_name']; ?>!</span>
        <a href="customer_logout.php" class="btn-secondary">Logout</a>
    </div>
    <p>Keranjang belanja Anda kosong.</p>
    <a href="products.php" class="btn">Mulai Belanja</a>

  <?php else: ?>

    <!-- === BAGIAN UTAMA (KERANJANG + INFORMASI PEMBELI DIGABUNG) === -->
    <section class="checkout-container">
      <form method="post" action="">
        <table>
          <thead>
            <tr>
              <th>Item</th>
              <th>Harga</th>
              <th>Jumlah</th>
              <th>Subtotal</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($cart_items as $key => $item): ?>
            <tr>
              <td><?= $item['name']; ?> (<?= ucfirst($item['type']); ?>)</td>
              <td>Rp <?= number_format($item['price'], 0, ',', '.'); ?></td>
              <td><input type="number" name="quantities[<?= $key; ?>]" value="<?= $item['quantity']; ?>" min="1" style="width:60px;"></td>
              <td>Rp <?= number_format($item['subtotal'], 0, ',', '.'); ?></td>
              <td><a href="?remove=<?= $key; ?>" class="btn-secondary" onclick="return confirm('Hapus item ini?')">Hapus</a></td>
            </tr>
            <?php endforeach; ?>
            <tr style="font-weight: bold; background-color:#f4e4c1;">
              <td colspan="3">Total</td>
              <td>Rp <?= number_format($cart_total, 0, ',', '.'); ?></td>
              <td></td>
            </tr>
          </tbody>
        </table>

        <!-- Tombol update -->
        <?php if (!$show_checkout_form): ?>
          <button type="submit" name="update_cart" class="btn">Update Keranjang</button>
        <?php endif; ?>
      </form>

      <!-- === FORM PEMBELI & BANK === -->
      <?php if ($show_checkout_form): ?>
        <div class="checkout-info">
          <h3>Informasi Pembeli</h3>
          <form method="post" action="backend/process_payment.php" enctype="multipart/form-data">
            <label>Nama Lengkap:</label>
            <input type="text" name="nama_pembeli" value="<?= $customer_data['nama_lengkap']; ?>" required>
            <label>Email:</label>
            <input type="email" name="email" value="<?= $customer_data['email']; ?>" required>
            <label>No. Telepon:</label>
            <input type="tel" name="phone" value="<?= $customer_data['phone']; ?>" required>
            <label>Alamat Lengkap:</label>
            <textarea name="alamat" rows="3" required><?= $customer_data['alamat']; ?></textarea>

            <h3>Informasi Transfer Bank</h3>
            <p style="background: #f4e4c1; padding: 1rem; border-radius: 8px;">
              <strong>Rekening Tujuan:</strong><br>
              Mandiri: 1390088899913 a.n. Adam Bakery<br>
              Qris: <a href="assets/qris.jpg" target="_blank">Lihat QRIS di sini</a>
            </p>

            <label>Nama Pemilik Rekening (Pengirim):</label>
            <input type="text" name="account_name" required>
            <label>Nomor Rekening (Pengirim):</label>
<<<<<<< HEAD
            <label>Jika Menggunakan Qris, Maka Ketik "-"</label>
=======
>>>>>>> 5163a4946f68ea1915a84c755a0899aa86013e39
            <input type="text" name="account_number" required>
            <label>Bank Tujuan:</label>
            <select name="bank_name" required>
              <option value="">Pilih Bank</option>
<<<<<<< HEAD
              <option value="Mandiri">Mandiri</option> 
=======
              <option value="Mandiri">Mandiri</option>
>>>>>>> 5163a4946f68ea1915a84c755a0899aa86013e39
              <option value="Lainnya">Lainnya</option>
            </select>
            <label>Jumlah Transfer:</label>
            <input type="number" name="transfer_amount" value="<?= $cart_total; ?>" required>
            <label>Bukti Transfer (Wajib):</label>
            <input type="file" name="transfer_proof" accept="image/*" required>

            <input type="hidden" name="total_amount" value="<?= $cart_total; ?>">
            <input type="hidden" name="customer_id" value="<?= $_SESSION['customer_id']; ?>">
            <button type="submit" class="btn">Proses Pembayaran</button>
          </form>
        </div>
      <?php endif; ?>
    </section>

  <?php endif; ?>
</main>


<?php include 'includes/footer.php'; ?>
