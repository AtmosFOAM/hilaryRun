/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Copyright (C) YEAR OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

\*---------------------------------------------------------------------------*/

#include "functionObjectTemplate.H"
#include "fvCFD.H"
#include "unitConversion.H"
#include "addToRunTimeSelectionTable.H"

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{

// * * * * * * * * * * * * * * Static Data Members * * * * * * * * * * * * * //

defineTypeNameAndDebug(nonUniformSSTFunctionObject, 0);

addRemovableToRunTimeSelectionTable
(
    functionObject,
    nonUniformSSTFunctionObject,
    dictionary
);


// * * * * * * * * * * * * * * * Global Functions  * * * * * * * * * * * * * //

extern "C"
{
    // dynamicCode:
    // SHA1 = 6aeb1d413c08c2505a166e07af16548122c0f3f4
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void nonUniformSST_6aeb1d413c08c2505a166e07af16548122c0f3f4(bool load)
    {
        if (load)
        {
            // code that can be explicitly executed after loading
        }
        else
        {
            // code that can be explicitly executed before unloading
        }
    }
}


// * * * * * * * * * * * * * * * Local Functions * * * * * * * * * * * * * * //

//{{{ begin localCode

//}}} end localCode


// * * * * * * * * * * * * * Private Member Functions  * * * * * * * * * * * //

const fvMesh& nonUniformSSTFunctionObject::mesh() const
{
    return refCast<const fvMesh>(obr_);
}


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

nonUniformSSTFunctionObject::nonUniformSSTFunctionObject
(
    const word& name,
    const Time& runTime,
    const dictionary& dict
)
:
    functionObjects::regionFunctionObject(name, runTime, dict)
{
    read(dict);
}


// * * * * * * * * * * * * * * * * Destructor  * * * * * * * * * * * * * * * //

nonUniformSSTFunctionObject::~nonUniformSSTFunctionObject()
{}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

bool nonUniformSSTFunctionObject::read(const dictionary& dict)
{
    if (false)
    {
        Info<<"read nonUniformSST sha1: 6aeb1d413c08c2505a166e07af16548122c0f3f4\n";
    }

//{{{ begin code
    
//}}} end code

    return true;
}


bool nonUniformSSTFunctionObject::execute()
{
    if (false)
    {
        Info<<"execute nonUniformSST sha1: 6aeb1d413c08c2505a166e07af16548122c0f3f4\n";
    }

//{{{ begin code
    
//}}} end code

    return true;
}


bool nonUniformSSTFunctionObject::write()
{
    if (false)
    {
        Info<<"write nonUniformSST sha1: 6aeb1d413c08c2505a166e07af16548122c0f3f4\n";
    }

//{{{ begin code
    #line 16 "controlDict.functions.nonUniformSST"
#include "mathematicalConstants.H"
    using namespace constant::mathematical;

    // Get index of patch
    label patchID = mesh().boundaryMesh().findPatchID("ground");

    // x position along the boundary
    const scalarField x = mesh().C().boundaryField()[patchID]
        .component(vector::X);

    // Read in the buoyancy
    volScalarField b
    (
        IOobject
        (
            "b",
            mesh().time().timeName(),
            mesh(),
            IOobject::MUST_READ
        ),
        mesh()
    );

    // Get reference to boundary value
    fixedGradientFvPatchScalarField& groundb
         = refCast<fixedGradientFvPatchScalarField>
    (
        b.boundaryFieldRef()[patchID]
    );
    scalarField& gradb = groundb.gradient();

    // Set the surface heat flux
    const scalar L = 5e5, ell = 5e4, H = 2e-5;
    for(label i = 0; i < x.size(); i++)
    {
        if (x[i] < -L+ell || x[i] > L-ell || (x[i] > -ell && x[i] < ell))
        {
            gradb[i] = H*sqr(Foam::sin((x[i]/ell+1)*pi/4));
        }
        else if (x[i] >= ell && x[i] <= L-ell)
        {
            gradb[i] = H;
        }
        else gradb[i] = 0;
    }

    b.write();
//}}} end code

    return true;
}


bool nonUniformSSTFunctionObject::end()
{
    if (false)
    {
        Info<<"end nonUniformSST sha1: 6aeb1d413c08c2505a166e07af16548122c0f3f4\n";
    }

//{{{ begin code
    
//}}} end code

    return true;
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

