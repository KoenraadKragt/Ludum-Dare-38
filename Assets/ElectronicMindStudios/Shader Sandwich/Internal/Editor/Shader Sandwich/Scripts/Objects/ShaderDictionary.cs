using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using SU = ShaderUtil;
using UnityEngine.Rendering;

[System.Serializable]
public class SDictionary<K,V>{// : MonoBehaviour, ISerializationCallbackReceiver
	public Dictionary<K,V> D = new Dictionary<K,V>();
	public List<K> Keys = new List<K>();
	public List<V> Values = new List<V>();
	public void Serialize(){
		Keys.Clear();
		Values.Clear();
		foreach( KeyValuePair<K,V> KeyValue in D){
			Keys.Add(KeyValue.Key);
			Values.Add(KeyValue.Value);
		}
	}
	public void Deserialize(){
		D = new Dictionary<K,V>();
		for (int i = 0;i<Keys.Count;i++){
			D[Keys[i]] = Values[i];
		}
	}
}
[System.Serializable]
public class SSDictionary{// : MonoBehaviour, ISerializationCallbackReceiver
	public Dictionary<string,string> D = new Dictionary<string,string>();
	public List<string> Keys = new List<string>();
	public List<string> Values = new List<string>();
	public void Serialize(){
		
		Keys.Clear();
		Values.Clear();
		foreach( KeyValuePair<string,string> KeyValue in D){
			Keys.Add(KeyValue.Key);
			Values.Add(KeyValue.Value);
		}
	}
	public void Deserialize(){
		D = new Dictionary<string,string>();
		for (int i = 0;i<Keys.Count;i++){
			D[Keys[i]] = Values[i];
		}
	}
}
[System.Serializable]
public class SBDictionary{// : MonoBehaviour, ISerializationCallbackReceiver
	public Dictionary<string,bool> D = new Dictionary<string,bool>();
	public List<string> Keys = new List<string>();
	public List<bool> Values = new List<bool>();
	public void Serialize(){
		Keys.Clear();
		Values.Clear();
		foreach( KeyValuePair<string,bool> KeyValue in D){
			Keys.Add(KeyValue.Key);
			Values.Add(KeyValue.Value);
		}
	}
	public void Deserialize(){
		D = new Dictionary<string,bool>();
		for (int i = 0;i<Keys.Count;i++){
			D[Keys[i]] = Values[i];
		}
	}
}
[System.Serializable]
public class SVDictionary : ISerializationCallbackReceiver{
	public Dictionary<string,ShaderVar> _D = new Dictionary<string,ShaderVar>();
	public Dictionary<string,ShaderVar> D{
		get{
			if (_D==null){
				D = new Dictionary<string,ShaderVar>();
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
	public List<string> Keys = new List<string>();
	public List<ShaderVar> Values = new List<ShaderVar>();
	public SVDictionary(){
		D = new Dictionary<string,ShaderVar>();
		Keys = new List<string>();
		Values = new List<ShaderVar>();
		//Debug.Log("ConstructionYup :D");
	}
	public void OnBeforeSerialize(){
		Keys = new List<string>();
		Values = new List<ShaderVar>();
		foreach( KeyValuePair<string,ShaderVar> KeyValue in D){
			Keys.Add(KeyValue.Key);
			Values.Add(KeyValue.Value);
		}
		//Debug.Log("Serialize");
	}
	public void OnAfterDeserialize(){
		D = new Dictionary<string,ShaderVar>();
		for (int i = 0;i<Keys.Count;i++){
			D[Keys[i]] = Values[i];
		}
		//Debug.Log("Deserialized!");
	}
}
[System.Serializable]
public class SSLLDictionary : ISerializationCallbackReceiver{
	public Dictionary<string,ShaderLayerList> _D = new Dictionary<string,ShaderLayerList>();
	public Dictionary<string,ShaderLayerList> D{
		get{
			if (_D==null){
				D = new Dictionary<string,ShaderLayerList>();
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
	public List<string> Keys = new List<string>();
	public List<ShaderLayerList> Values = new List<ShaderLayerList>();
	public SSLLDictionary(){
		D = new Dictionary<string,ShaderLayerList>();
		Keys = new List<string>();
		Values = new List<ShaderLayerList>();
		//Debug.Log("ConstructionYup :D");
	}
	public void OnBeforeSerialize(){
		Keys = new List<string>();
		Values = new List<ShaderLayerList>();
		foreach( KeyValuePair<string,ShaderLayerList> KeyValue in D){
			Keys.Add(KeyValue.Key);
			Values.Add(KeyValue.Value);
		}
		//Debug.Log("Serialize");
	}
	public void OnAfterDeserialize(){
		D = new Dictionary<string,ShaderLayerList>();
		for (int i = 0;i<Keys.Count;i++){
			D[Keys[i]] = Values[i];
		}
		//Debug.Log("Deserialized!");
	}
}