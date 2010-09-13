<h1>Your Amazon Cart</h1>

<? if (!empty($errors)): ?>
<h2>Errors:</h2>
<ul style="color: red">
	<? foreach ($errors AS $error): ?>
		<li><?=$error?></li>
	<? endforeach ?>
</ul>
<? endif ?>

<table>
	<tr>
		<th>Item</th>
		<th>Qty</th>
		<th>Price</th>
		<th>Total</th>
	</tr>
	<? foreach ($cart->CartItems->CartItem AS $item): ?>
		<tr>
			<td><?=$item->Title?></td>
			<td><?=$item->Quantity?></td>
			<td><?=$item->Price->FormattedPrice?></td>
			<td><b><?=$item->ItemTotal->FormattedPrice?></b></td>
		</tr>
	<? endforeach ?>
	<tr style="font-size: 120%;">
		<td align="right" colspan="3"><b>Total:</b></td>
		<td><b><?=$cart->SubTotal->FormattedPrice?></b></td>
	</tr>
	<tr>
		<td colspan="4" align="right">
			<input type="button" style="font-size: 20px" value="Checkout on Amazon" onclick="window.location='<?=$cart->PurchaseURL?>'"/>
			<br/><small>(If that doesn't work, <a href="<?=$cart->PurchaseURL?>">click here</a>)</small>
	</tr>
</table>