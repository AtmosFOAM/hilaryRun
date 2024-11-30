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

defineTypeNameAndDebug(nonUniformNuFunctionObject, 0);

addRemovableToRunTimeSelectionTable
(
    functionObject,
    nonUniformNuFunctionObject,
    dictionary
);


// * * * * * * * * * * * * * * * Global Functions  * * * * * * * * * * * * * //

extern "C"
{
    // dynamicCode:
    // SHA1 = 378ba8fdd8a5cbb2aec798877125bac075d87c40
    //
    // unique function name that can be checked if the correct library version
    // has been loaded
    void nonUniformNu_378ba8fdd8a5cbb2aec798877125bac075d87c40(bool load)
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

const fvMesh& nonUniformNuFunctionObject::mesh() const
{
    return refCast<const fvMesh>(obr_);
}


// * * * * * * * * * * * * * * * * Constructors  * * * * * * * * * * * * * * //

nonUniformNuFunctionObject::nonUniformNuFunctionObject
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

nonUniformNuFunctionObject::~nonUniformNuFunctionObject()
{}


// * * * * * * * * * * * * * * * Member Functions  * * * * * * * * * * * * * //

bool nonUniformNuFunctionObject::read(const dictionary& dict)
{
    if (false)
    {
        Info<<"read nonUniformNu sha1: 378ba8fdd8a5cbb2aec798877125bac075d87c40\n";
    }

//{{{ begin code
    
//}}} end code

    return true;
}


bool nonUniformNuFunctionObject::execute()
{
    if (false)
    {
        Info<<"execute nonUniformNu sha1: 378ba8fdd8a5cbb2aec798877125bac075d87c40\n";
    }

//{{{ begin code
    
//}}} end code

    return true;
}


bool nonUniformNuFunctionObject::write()
{
    if (false)
    {
        Info<<"write nonUniformNu sha1: 378ba8fdd8a5cbb2aec798877125bac075d87c40\n";
    }

//{{{ begin code
    #line 15 "controlDict.functions.nonUniformNu"
IOdictionary envDict
    (
        IOobject
        (
            "environmentalProperties", mesh().time().constant(), mesh(),
            IOobject::MUST_READ, IOobject::NO_WRITE
        )
    );
    const scalar kappa = readScalar(envDict.lookup("kappa"));
    const dimensionedScalar uStar(envDict.lookup("uStar"));
    const dimensionedScalar nuMax(envDict.lookup("nuMax"));

    // Distance from the ground
    volScalarField groundDistance
    (
        IOobject("groundDistance", mesh().time().constant(), mesh(), IOobject::MUST_READ),
        mesh()
    );
    
    // Viscosity that varys in space
    volScalarField nu
    (
        IOobject("nu", mesh().time().constant(), mesh(), IOobject::NO_READ),
        min(nuMax, kappa*uStar*groundDistance)
    );

    nu.write();
//}}} end code

    return true;
}


bool nonUniformNuFunctionObject::end()
{
    if (false)
    {
        Info<<"end nonUniformNu sha1: 378ba8fdd8a5cbb2aec798877125bac075d87c40\n";
    }

//{{{ begin code
    
//}}} end code

    return true;
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

