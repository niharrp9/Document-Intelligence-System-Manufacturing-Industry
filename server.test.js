const test=require('node:test'),assert=require('node:assert/strict');
const {answer}=require('./server');
test('returns a cited document answer',()=>{const r=answer('What is required before operation?');assert.equal(r.state,'grounded_answer');assert.ok(r.citations.length);});
test('abstains when no document supports question',()=>assert.deepEqual(answer('What is the cafeteria menu?'),{state:'insufficient_evidence',answer:'Not available in the documents.',citations:[]}));
test('escalates urgent safety language',()=>assert.equal(answer('There is an injury').state,'escalate'));
