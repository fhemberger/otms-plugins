// Only submit form if a language/project variant is checked
function checkPublishForm()
{
	if (!isLanguageChecked() || !isProjectChecked())
	{
		alert('At least one project variant and one language variant must be selected.');
		return false;
	} else {
		document.publishForm.submit();
	}
}


// Is one language variant checked?
function isLanguageChecked()
{
	if (typeof document.publishForm.lng.length == 'undefined')
	{
		if (document.publishForm.lng.checked === true) return true;
	} else {
		for(i=0;i<document.publishForm.lng.length;i++) if (document.publishForm.lng[i].checked === true) return true;
	}
	return false;
}


// Is one project variant checked?
function isProjectChecked()
{
	if (typeof document.publishForm.prj.length == 'undefined')
	{
		if (document.publishForm.prj.checked === true) return true;
	} else {
		for(i=0;i<document.publishForm.prj.length;i++) if (document.publishForm.prj[i].checked === true) return true;
	}
	return false;
}
