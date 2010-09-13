

function toggleModule( image, startrow, endrow) {
  var thisImg =  document.getElementById( 'toggle' + image );
  var thisRow =  document.getElementById( 'bomRow' + image );
  
  var RegularExpression = /plus\.png/;

  for (row = startrow; row <= endrow; row++) {
    var currRow = document.getElementById( 'bomRow' + row );
    if ( thisImg.src.search(RegularExpression) != -1) {
      currRow.style.display = "block";
      currRow.style.display = "table-row";
    } else {
      currRow.style.display = "none";
    }
  }

  if ( thisImg.src.search(RegularExpression) != -1) {
    thisImg.src = "css/images/minus.png";
  } else {
    thisImg.src = "css/images/plus.png";
  }
}

