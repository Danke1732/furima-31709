function calculation() {
  const price = document.getElementById('item-price');
  const tax_price = document.getElementById('add-tax-price');
  const profit = document.getElementById('profit');

  let calc_tax_price = price.value / 10;

  tax_price.innerHTML = Math.floor(calc_tax_price).toLocaleString();
  profit.innerHTML = Math.floor(price.value - calc_tax_price).toLocaleString();
}
if (document.URL.match( /new/ ) || document.URL.match( /edit/ )) {
  setInterval(calculation, 500);
}