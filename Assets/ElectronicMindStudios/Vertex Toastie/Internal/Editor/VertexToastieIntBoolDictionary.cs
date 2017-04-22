using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using SU = ShaderUtil;
using UnityEngine.Rendering;


[System.Serializable]
public class IntBoolDictionary : ISerializationCallbackReceiver{
	public Dictionary<int,bool> _D = new Dictionary<int,bool>();
	public Dictionary<int,bool> D{
		get{
			if (_D==null){
				D = new Dictionary<int,bool>();
				for (int i = 0;i<Keys.Count;i++){
					D[Keys[i]] = Values[i];
				}
			}
			return _D;
		}
		set{
			_D = value;
		}
	}
	public List<int> Keys = new List<int>();
	public List<bool> Values = new List<bool>();
	public IntBoolDictionary(){
		D = new Dictionary<int,bool>();
		Keys = new List<int>();
		Values = new List<bool>();
		//Debug.Log("ConstructionYup :D");
	}
	public void OnBeforeSerialize(){
		Keys = new List<int>();
		Values = new List<bool>();
		foreach( KeyValuePair<int,bool> KeyValue in D){
			Keys.Add(KeyValue.Key);
			Values.Add(KeyValue.Value);
		}
		//Debug.Log("Serialize");
	}
	public void OnAfterDeserialize(){
		D = new Dictionary<int,bool>();
		for (int i = 0;i<Keys.Count;i++){
			D[Keys[i]] = Values[i];
		}
		//Debug.Log("Deserialized!");
	}
	public void Clear(){
		D.Clear();
		Keys.Clear();
		Values.Clear();
	}
}