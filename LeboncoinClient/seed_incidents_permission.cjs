const { Client } = require('pg');
const c = new Client({ host:'51.83.36.122', port:5432, user:'s4a14', password:'yeu&GZ165', database:'s4a14-leboncoin' });
c.connect()
  .then(() => c.query("INSERT INTO permission (idpermission, nompermission) VALUES (25, 'app.view.my_incidents') ON CONFLICT DO NOTHING"))
  .then(r => console.log('permission:', r.rowCount, 'row(s) inserted'))
  .then(() => c.query("INSERT INTO permettre (idpermission, idrole) VALUES (25, 2) ON CONFLICT DO NOTHING"))
  .then(r => console.log('permettre:', r.rowCount, 'row(s) inserted'))
  .catch(e => console.error('ERROR:', e.message))
  .finally(() => c.end());
