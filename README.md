# code-context
```python
def process_entry(entry):
    existing_doc = collection.find_one({'ducks': entry['ducks']})
    if not existing_doc:
        collection.insert_one(entry)
    else:
        update_trees(existing_doc, entry)

def update_trees(existing_doc, new_entry):
    for new_tree in new_entry['trees']:
        if not any(tree['tree'] == new_tree['tree'] for tree in existing_doc['trees']):
            collection.update_one({'_id': existing_doc['_id']}, {'$push': {'trees': new_tree}})
        else:
            update_rainbows(existing_doc, new_tree)

def update_rainbows(existing_doc, new_tree):
    for new_rainbow in new_tree['rainbows']:
        rainbow_query = {
            'ducks': existing_doc['ducks'], 
            'trees': {'$elemMatch': {'tree': new_tree['tree'], 'rainbows': {'$elemMatch': {'rainbow_id': new_rainbow['rainbow_id']}}}}
        }
        rainbow_exists = collection.find_one(rainbow_query)
        
        if not rainbow_exists:
            collection.update_one(
                {'_id': existing_doc['_id'], 'trees.tree': new_tree['tree']},
                {'$push': {'trees.$.rainbows': new_rainbow}}
            )
        else:
            update_books(existing_doc, new_tree, new_rainbow)

def update_books(existing_doc, new_tree, new_rainbow):
    # Find the index of the specific tree in the 'trees' array
    tree_index = next((i for i, tree in enumerate(existing_doc['trees']) if tree['tree'] == new_tree['tree']), None)

    # Find the index of the specific rainbow in the 'rainbows' array of the found tree
    if tree_index is not None:
        rainbow_index = next((i for i, rainbow in enumerate(existing_doc['trees'][tree_index]['rainbows']) if rainbow['rainbow_id'] == new_rainbow['rainbow_id']), None)

        if rainbow_index is not None:
            for new_book in new_rainbow['books']:
                # Construct the update path with the found indices
                update_path = f'trees.{tree_index}.rainbows.{rainbow_index}.books'
                collection.update_one(
                    {'_id': existing_doc['_id']},
                    {'$push': {update_path: new_book}}
                )
```
