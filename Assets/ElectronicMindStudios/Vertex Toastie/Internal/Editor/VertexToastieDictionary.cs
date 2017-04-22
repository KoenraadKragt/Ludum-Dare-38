using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using SU = ShaderUtil;
using UnityEngine.Rendering;


[System.Serializable]
public class GOVBDictionary : ISerializationCallbackReceiver{
	public Dictionary<GameObject,VertexToastieIterativeVertexAOBaker> _D = new Dictionary<GameObject,VertexToastieIterativeVertexAOBaker>();
	public Dictionary<GameObject,VertexToastieIterativeVertexAOBaker> D{
		get{
			if (_D==null){
				D = new Dictionary<GameObject,VertexToastieIterativeVertexAOBaker>();
				for (int i = 0;i<Keys.Count;i++){
					if (Keys[i]!=null)
						D[Keys[i]] = Values[i];
				}
			}
			return _D;
		}
		set{
			_D = value;
		}
	}
	public List<GameObject> Keys = new List<GameObject>();
	public List<VertexToastieIterativeVertexAOBaker> Values = new List<VertexToastieIterativeVertexAOBaker>();
	public GOVBDictionary(){
		D = new Dictionary<GameObject,VertexToastieIterativeVertexAOBaker>();
		Keys = new List<GameObject>();
		Values = new List<VertexToastieIterativeVertexAOBaker>();
		//Debug.Log("ConstructionYup :D");
	}
	public void OnBeforeSerialize(){
		Keys = new List<GameObject>();
		Values = new List<VertexToastieIterativeVertexAOBaker>();
		foreach( KeyValuePair<GameObject,VertexToastieIterativeVertexAOBaker> KeyValue in D){
			Keys.Add(KeyValue.Key);
			Values.Add(KeyValue.Value);
		}
		//Debug.Log("Serialize");
	}
	public void OnAfterDeserialize(){
		D = new Dictionary<GameObject,VertexToastieIterativeVertexAOBaker>();
		for (int i = 0;i<Keys.Count;i++){
			if (Keys[i]!=null)
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