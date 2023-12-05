# code-context
```python
def filter_new_readings(data):
    new_readings = []
    for entry in data:
        if not collection.find_one({'unique_identifier': entry['unique_identifier']}):
            new_readings.append(entry)
    return new_readings

def process_files(file_paths):
    for file_path in file_paths:
        data = read_json_file(file_path)
        new_data = filter_new_readings(data)
        if new_data:
            collection.insert_many(new_data)

process_files(file_paths)
```
