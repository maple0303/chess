using UnityEngine;
using UnityEditor;

public class CBattleEditor : EditorWindow
{
    string myString = "";
    bool groupEnabled;
    bool myBool = true;
    float myFloat = 1.23f;

    // Add menu named "My Window" to the Window menu
    [MenuItem("Tools/Battle Editor")]
    static void Init()
    {
        // Get existing open window or if none, make a new one:
        CBattleEditor window = (CBattleEditor)EditorWindow.GetWindow(typeof(CBattleEditor));
        window.Show();
    }

    void OnGUI()
    {
        GUILayout.Label("创建角色", EditorStyles.boldLabel);
        myString = EditorGUILayout.TextField("角色1", "");
        myString = EditorGUILayout.TextField("角色2", "");
        GUILayout.Button("创建", EditorStyles.miniButton);

        groupEnabled = EditorGUILayout.BeginToggleGroup("Optional Settings", groupEnabled);
        myBool = EditorGUILayout.Toggle("Toggle", myBool);
        myFloat = EditorGUILayout.Slider("Slider", myFloat, -3, 3);
        EditorGUILayout.EndToggleGroup();
    }
}