using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FilterSetter : MonoBehaviour
{
    public enum filterType
    {
        Gaussian,
        Sobel,
        Laplacian
    }

    public enum filterSize
    {
        F3x3 = 1,
        F5x5 = 2,
        F7x7 = 3
    }

    [SerializeField] private Material mtl;
    [SerializeField] private filterType mtlType;
    [SerializeField] private filterSize mtlSize;

    /*private float[] GenerateKernel()
    {
        float[][] kernel3x3 = new float[][]
        {
            new float[]
            {
                0.0625f, 0.125f, 0.0625f,
                0.125f, 0.250f, 0.125f,
                0.0625f, 0.125f, 0.0625f
            }

            new float[]
            {
                0, 1,  0,
                    1, -4, 1,
                    0, 1,  0
            }
        };

        switch (filterType)
        {
            case filterType.Gaussian:
                break;
            case filterType.Sobel:
                break; 
            case filterType.Laplacian:
                break;
        }
    }*/

    private void UpdateFilter()
    {
        if(mtl == null) return;

        //mtl.SetInt("_kernelSize", (int)filterSize);
    }
    private void OnValidate()
    {
        
    }

    private void Awake()
    {
        
    }
}
