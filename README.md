# code-context

```python
def process_entry(entry):
    # Check if a document with the same 'ducks' value exists
    existing_doc = collection.find_one({'ducks': entry['ducks']})

    if not existing_doc:
        # If 'ducks' does not exist, insert the entire new entry
        collection.insert_one(entry)
    else:
        # If 'ducks' exists, check and update 'trees' and 'rainbows'
        update_trees(existing_doc, entry)

def update_trees(existing_doc, new_entry):
    for new_tree in new_entry['trees']:
        if not any(tree['tree'] == new_tree['tree'] for tree in existing_doc['trees']):
            # If this 'tree' does not exist, append it to 'trees'
            collection.update_one(
                {'_id': existing_doc['_id']},
                {'$push': {'trees': new_tree}}
            )
        else:
            # If 'tree' exists, check and update 'rainbows'
            update_rainbows(existing_doc, new_tree)

def update_rainbows(existing_doc, new_tree):
    for new_rainbow in new_tree['rainbows']:
        if not collection.find_one(
            {'ducks': existing_doc['ducks'], 'trees': {'$elemMatch': {'tree': new_tree['tree'], 'rainbows': {'$elemMatch': {'rainbow_id': new_rainbow['rainbow_id']}}}}}
        ):
            # If 'rainbow_id' does not exist, append it to the corresponding 'tree' in 'rainbows'
            collection.update_one(
                {'_id': existing_doc['_id'], 'trees.tree': new_tree['tree']},
                {'$push': {'trees.$.rainbows': new_rainbow}}
            )

```
