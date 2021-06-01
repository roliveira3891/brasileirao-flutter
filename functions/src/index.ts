import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

export const novaTorcida = functions.firestore.document('usuarios/{userId}').onWrite(contador);

async function contador(change:any, constex: any){
  const valorAntigo = change.before.exists ? change.before.data() : null;
  const valorNovo = change.after.exists ? change.after.data() : null;

  if(valorAntigo!==null && valorAntigo.time_id===valorNovo.time_id){
    return null;
  }

  var batch = db.batch();
  var timeNovoRef = db.doc(`times/${valorNovo.time_id}`);

  batch.set(timeNovoRef,{
    torcedores: admin.firestore.FieldValue.increment(1)
  },{
    merge:true
  });

  if(valorAntigo!==null){
    var timeAntigoRef = db.doc(`times/${valorAntigo.time_id}`);
    batch.set(timeAntigoRef,{torcedores:admin.firestore.FieldValue.increment(-1)},{merge:false});
  }

  return await batch.commit();
}