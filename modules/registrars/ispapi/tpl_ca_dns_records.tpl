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
{elseif $dnsSecFixSuccess === true}
	<div class="alert alert-success">
		<strong>{$LANG.success}</strong><br>
		{if $LANG['locale'] eq 'de_DE'}
			Der DS Record wurde bei der Registry hinterlegt. Bis DNSSec korrekt funktioniert können noch bis zu 6h vergehen.
		{else}
			The DS record has been stored in the registry. It can take up to 6 hours until DNSSec works correctly.
		{/if}
	</div>
{elseif $dnsSecFixSuccess === false}
	<div class="alert alert-danger">
		<strong>{$LANG.error}</strong><br>
		{if $LANG['locale'] eq 'de_DE'}
			Der DS Record konnte nicht automatisch hinterlegt werden. Bitte tragen Sie einen der unten angezeigten DS Records manuell ein.
		{else}
			The DS Record could not be stored automatically. Please enter one of the DS Records displayed below manually.
		{/if}
	</div>
{/if}

{assign var=counter value=0}
<form id="dns_records_form" method="post" action="">
	<div class="panel panel-sidebar">
		<div class="panel-heading">
			<h3 class="panel-title">
				<i class="fas fa-key"></i>&nbsp;DNSSec&nbsp;
				<i class="fas fa-chevron-up panel-minimise minimised pull-right"></i>
				{if $dnssec}
					{if $dnssec_status['status']}
						<span class="label label-success pull-right" style="margin: 3px 12px;">{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate('active', $LANG['locale'])}</span>
					{else}
						<span class="label label-danger pull-right" style="margin: 3px 12px;">{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate('error', $LANG['locale'])}</span>
					{/if}
				{else}
					<span class="label label-warning pull-right" style="margin: 3px 12px;">{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate('inactive', $LANG['locale'])}</span>
				{/if}
			</h3>
		</div>
		<div class="panel-body" style="display: none; font-size: 13.5px">
			<table class="table" style="margin-bottom: 0;">
				<tbody>
				<tr>
					<td style="border-top: none">Aktiv</td>
					<td style="border-top: none">
						<label style="display: flex; align-items: center;">
							<input type="checkbox" name="dnssec" id="dnssec" value="1" {if $dnssec} checked {/if} style="margin-top: 0">
							<span style="padding-left: 6px;">DNSSec aktivieren</span>
						</label>
					</td>
				</tr>
				{if $dnssec}
					<tr>
						<td>DS Records</td>
						<td>
							{foreach from=$ds_records item=dsRecord}
								<div class="zone_dnssec_ds_record">
									<div style="display: flex; justify-content: space-between;">
										<span style="white-space: nowrap">{$dsRecord['key_tag']} {$dsRecord['algorithm']} {$dsRecord['digest_type']} {$dsRecord['digest']}</span>
										<a href="#" class="zone_dnssec_ds_popup_show">Details anzeigen</a>
									</div>
									<div class="zone_dnssec_ds_overlay" style="display: none;">
										<div class="zone_dnssec_ds_popup">
											<div>
												<div class="zone_dnssec_ds_popup_title">DS Record</div>
												<a href="#" class="clickable zone_dnssec_ds_popup_close">Fenster schliessen</a>
											</div>
											<div class="zone_dnssec_ds_popup_description">
												Tragen Sie folgende Daten bei Ihrem Domainregistrar ein.
											</div>
											<div class="zone_dnssec_popup_datacontainer">
												<div class="zone_dnssec_ds_popup_label">DS Record</div>
												<div class="zone_dnssec_ds_popup_field ds_record">{$domain_name} 3600 IN DS {$dsRecord['key_tag']} {$dsRecord['algorithm']} {$dsRecord['digest_type']}<br>{$dsRecord['digest']}</div>
												<div class="zone_dnssec_ds_popup_label">Digest</div>
												<div class="zone_dnssec_ds_popup_field digest">{$dsRecord['digest']}</div>
												<div class="zone_dnssec_ds_popup_label">Digest Type</div>
												<div class="zone_dnssec_ds_popup_field digestType">{$dsRecord['digest_type']} - SHA-256</div>
												<div class="zone_dnssec_ds_popup_label">Algorithm</div>
												<div class="zone_dnssec_ds_popup_field algorithm">{$dsRecord['algorithm']} - RSA/SHA-256</div>
												<div class="zone_dnssec_ds_popup_label">Public Key</div>
												<div class="zone_dnssec_ds_popup_field publicKey">{$dsRecord['public_key']}</div>
												<div class="zone_dnssec_ds_popup_label">Key Tag</div>
												<div class="zone_dnssec_ds_popup_field keyTag">{$dsRecord['key_tag']}</div>
												<div class="zone_dnssec_ds_popup_label">Protocol</div>
												<div class="zone_dnssec_ds_popup_field protocol">{$dsRecord['protocol']}</div>
												<div class="zone_dnssec_ds_popup_label">Flags</div>
												<div class="zone_dnssec_ds_popup_field flags">{$dsRecord['flags']}</div>
											</div>
										</div>
									</div>
								</div>
							{/foreach}
						</td>
					</tr>
					{if $dnssec_status}
						<tr>
							<td>Status</td>
							<td>
								{assign var="translation_key" value="dnssec_status_`$dnssec_status['status_key']`"}
								{if $dnssec_status['status']}
									<span class="dns_circle on"></span> <strong>{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate($translation_key, $LANG['locale'])}</strong>
								{else}
									<span class="dns_circle off"></span> <strong>{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate($translation_key, $LANG['locale'])}</strong>
									{if isset($ds_records[1])}
										<div>
											<input id="fix-ds-record-button" class="btn btn-large btn-primary" type="button" style="margin-top: 6px;"
												   value="{WHMCS\Module\Registrar\Hosttech\HosttechDns::translate('dnssec_ds_error_autofix', $LANG['locale'])}">
										</div>
									{/if}
								{/if}
							</td>
						</tr>
					{/if}
				{/if}
				</tbody>
			</table>
		</div>
	</div>

	{foreach from=$record_types item=fields key=record_type}
		<div style="margin-bottom: 24px;">
			<div style="display: flex; align-items: center; justify-content: space-between;">
				<h4>{$record_type} Records</h4>
				<a href="#" class="add_record">+ {if $LANG['locale'] eq 'de_DE'} {$record_type}  Record hinzufügen {else} Add {$record_type} record {/if}</a>
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

<form id="fix-ds-record-form" method="post" action="">
	<input type="hidden" name="fix_ds_record"
		   value="{$ds_records[1]['key_tag']} {$ds_records[1]['algorithm']} {$ds_records[1]['digest_type']} {$ds_records[1]['digest']}">
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
				$('.zone_dnssec_ds_popup_close').on('click', function(){
					$(this).closest('.zone_dnssec_ds_overlay').hide();
				});
				$('.zone_dnssec_ds_popup_show').on('click', function(){
					$(this).closest('.zone_dnssec_ds_record').find('.zone_dnssec_ds_overlay').show();
				});
				$('#fix-ds-record-button').on('click', function(){
					$('#fix-ds-record-form').submit();
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

		.dns_circle {
			display: inline-block;
			width: 12px;
			height: 12px;
			border-radius: 12px;
			background-color: rgba(0,0,0,.2);
			border: 1px solid rgba(0,0,0,.3);
		}

		.dns_circle.on, .on .dns_circle {
			background-color: #2ade00;
			border: 1px solid #24c400;
		}

		.dns_circle.off {
			background-color:red;
			border:1px solid #c40000
		}

		.zone_dnssec_ds_overlay {
			display:none;
			position:fixed;
			z-index:100;
			background-color:rgba(255,255,255,.9);
			left:0;
			top:0;
			height:100%;
			width:100%
		}
		.zone_dnssec_ds_popup {
			width:600px;
			height:720px;
			max-height:-webkit-calc(100% - 100px);
			max-height:calc(100% - 100px);
			margin:50px auto;
			background-color:#FFF;
			box-shadow:2px 2px 7px 0 rgba(50,50,50,.8);
			padding:20px
		}
		.zone_dnssec_ds_popup_title {
			font-size:16px;
			font-weight:700
		}
		.zone_dnssec_ds_popup_close {
			position:absolute;
			margin-top:-22px;
			margin-left:450px
		}
		.zone_dnssec_ds_popup_description {
			margin:10px 0
		}
		.zone_dnssec_popup_datacontainer {
			max-height:-webkit-calc(100% - 65px);
			max-height:calc(100% - 65px);
			overflow-y:auto
		}
		.zone_dnssec_ds_popup_label {
			font-weight:700;
			margin-bottom:5px
		}
		.zone_dnssec_ds_popup_field {
			margin-bottom:13px;
			border:1px solid #DDD;
			background-color:#EEE;
			border-radius:2px;
			padding:5px;
			width:100%
		}
	</style>
{/literal}


