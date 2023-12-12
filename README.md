# code-context

```cs
using UnityEngine;

public class ReplaceChild : MonoBehaviour
{
    public GameObject parentGameObject; // Assign this in the Inspector
    public GameObject newGameObjectPrefab; // Assign the prefab of the new GameObject

    void Start()
    {
        ReplaceFirstEmptySpaceChild();
    }

    void ReplaceFirstEmptySpaceChild()
    {
        for (int i = 0; i < parentGameObject.transform.childCount; i++)
        {
            Transform child = parentGameObject.transform.GetChild(i);

            if (child.CompareTag("EmptySpace"))
            {
                // Instantiate the new GameObject at the parent's position but don't set it as a child yet
                GameObject newChild = Instantiate(newGameObjectPrefab, parentGameObject.transform.position, Quaternion.identity);

                // Set the new child's parent
                newChild.transform.SetParent(parentGameObject.transform);

                // Move the new GameObject to match the hierarchy position of the found child
                newChild.transform.SetSiblingIndex(child.GetSiblingIndex());

                // Destroy the old child GameObject
                Destroy(child.gameObject);
                
                // Break the loop after replacing the first matching child
                break;
            }
        }
    }
}
```
