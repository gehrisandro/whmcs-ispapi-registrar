<h3 style="margin-bottom:25px;">DNS Records Management</h3>

{if $success}
	<div class="alert alert-success">
		<strong>{$LANG.success}</strong><br>
		{$LANG.changessavedsuccessfully}
	</div>
{elseif $errors}
	<div class="alert alert-danger">
		<strong>{$LANG.error}</strong><br>
		{if $LANG['locale'] eq 'de_DE'}
			Ihre eingegebenen Daten sind ungültig. Bitte korrigieren Sie alle markierten Felder.
		{else}
			Your entered data is invalid. Please correct all marked fields.
		{/if}
	</div>
{/if}

{assign var=counter value=0}

<form id="dns_records_form" method="post" action="">
	{foreach from=$record_types item=fields key=record_type}
		<div style="margin-bottom: 24px;">
			<div style="display: flex; align-items: center; justify-content: space-between;">
				<h4>{$record_type} Records</h4>
				<a href="#" class="add_record">+ {$record_type} {if $LANG['locale'] eq 'de_DE'} Record hinzufügen {else} Add record {/if}</a>
			</div>
			<table class="table table-striped" style="margin-bottom: 0; {if $records->where('type', $record_type)->isEmpty()}display: none{/if}">
				<thead>
				<tr>
					{foreach from=$fields item=$field key=name}
						<th style="width:{$field['width']}px;">{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate($field['label'], $LANG['locale'])}</th>
					{/foreach}
					<th style="width: 30px"></th>
				</tr>
				</thead>
				<tbody>
				{foreach from=$records->where('type', $record_type) item=record key=key}
					{assign var=counter value=$counter+1}
					<tr class="record_row">
						<input class="form-control" type="hidden" name="records[{$counter}][id]" value="{$record['id']}">
						<input class="form-control" type="hidden" name="records[{$counter}][type]" value="{$record['type']}">
						{foreach from=$fields item=field key=name}
							<td>
								<div class="form-group{if $errors[$key][$name]} has-error{/if}">
									<input class="form-control" type="text" name="records[{$counter}][{$name}]" placeholder="{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate($field['placeholder'], $LANG['locale'])}" value="{$record[$name]}">
								</div>
							</td>
						{/foreach}
						<td style="vertical-align: middle;"><i class="fa fa-trash delete_record" aria-hidden="true" title="Delete" data-toggle="tooltip"></i></td>
					</tr>
				{/foreach}
				<tr class="record_template">
					<input class="form-control" type="hidden" name="records[temp][type]" value="{$record_type}" disabled>
					{foreach from=$fields item=field key=name}
						<td><input class="form-control" type="text" name="records[temp][{$name}]" placeholder="{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate($field['placeholder'], $LANG['locale'])}" disabled></td>
					{/foreach}
					<td style="vertical-align: middle;"><i class="fa fa-trash delete_record" aria-hidden="true" title="Delete" data-toggle="tooltip"></i></td>
				</tr>
				</tbody>
			</table>
		</div>
	{/foreach}
	
	<p class="text-center">
		<input class="btn btn-large btn-primary" type="submit" value="{$LANG.clientareasavechanges}">
	</p>
</form>

{literal}
	<script type="text/javascript">
		var record_count = {/literal}{$counter}{literal}
		
		$(function(){
			$('.add_record').on('click', function(e){
				e.preventDefault();
				record_count++;
				$(this).parent().parent().find('table').css('display', '');
				var record_template = $(this).parent().parent().find('.record_template');
				var record_row = record_template.html();
				record_row = record_row.replace(/\[temp\]/g, '['+record_count+']');
				record_row = record_row.replace(/disabled/g, '');
				record_row = '<tr class="record_row">' + record_row + '</tr>';
				$(record_row).insertBefore(record_template);
			});
			$('#dns_records_form').on('click', '.delete_record', function(){
				$(this).parent().parent().remove();
			});
		});
	</script>

	<style>
		.delete_record {
			cursor: pointer;
		}

		.record_template {
			display: none;
		}
		
		.record_row .form-group{
			margin-bottom: 0;
		}
	</style>
{/literal}
