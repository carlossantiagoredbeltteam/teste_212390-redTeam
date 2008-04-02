<h1>Shopping List</h1>
<? if (!empty($list->suppliers)): ?>
	<? foreach ($list->suppliers AS $supplier): ?>
		<? $parts = $list->getSupplierParts($supplier->id); ?>
		
		<? if ($supplier->id): ?>
			<h2><?= $supplier->get('name') ?></h2>
			<p>
				<b>Website:</b> <a href="<?=$supplier->get('website')?>"><?=$supplier->get('website')?></a><br/>
				<?= $supplier->get('description')?>
			</p>
			<?
				//some suppliers have a different way of showing their part lists.
				switch(strtolower($supplier->get('name')))
				{
					case 'amazon':
						echo Controller::byName('supplier')->renderView('amazon_parts_list', array(
							'supplier' => $supplier,
							'parts' => $parts
						));				
						break;
				
					case '':
						echo Controller::byName('supplier')->renderView('no_supplier_parts_list', array(
							'supplier' => $supplier,
							'parts' => $parts,
							'uniques' => $no_suppliers
						));
						break;
							
					case 'mouser':
						echo Controller::byName('supplier')->renderView('mouser_parts_list', array(
							'supplier' => $supplier,
							'parts' => $parts
						));				
						break;
					
					case 'farnell':
						echo Controller::byName('supplier')->renderView('farnell_parts_list', array(
							'supplier' => $supplier,
							'parts' => $parts
						));				
						break;					
				
					case 'rs':
						echo Controller::byName('supplier')->renderView('rs_parts_list', array(
							'supplier' => $supplier,
							'parts' => $parts
						));				
						break;

					case 'digikey':
						echo Controller::byName('supplier')->renderView('digikey_parts_list', array(
							'supplier' => $supplier,
							'parts' => $parts
						));				
						break;
					
					default:
						echo Controller::byName('supplier')->renderView('generic_parts_list', array(
							'supplier' => $supplier,
							'parts' => $parts
						));
						break;
				}
			?>
		<? endif ?>
	<? endforeach ?>
<? else: ?>
	<b>No parts to supply found!</b>
<? endif ?>