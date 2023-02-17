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

Description
    Template for use with codeStream.

\*---------------------------------------------------------------------------*/

#include "dictionary.H"
#include "Ostream.H"
#include "Pstream.H"
#include "unitConversion.H"

//{{{ begin codeInclude
#line 24 "/home/hilary/OpenFOAM/hilary-7/run/hilary/GABLS_1d_SBL/exnerFoamTurbulence2/0/epsilon.#codeStream"
#include "fvCFD.H"
//}}} end codeInclude

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{

// * * * * * * * * * * * * * * * Local Functions * * * * * * * * * * * * * * //

//{{{ begin localCode

//}}} end localCode


// * * * * * * * * * * * * * * * Global Functions  * * * * * * * * * * * * * //

extern "C"
{
    void codeStream_361b83285c26b9e1670df7b4d839c17eebe679ae
    (
        Ostream& os,
        const dictionary& dict
    )
    {
//{{{ begin code
        #line 39 "/home/hilary/OpenFOAM/hilary-7/run/hilary/GABLS_1d_SBL/exnerFoamTurbulence2/0/epsilon.#codeStream"
// Constants to calculate epsilon
        const scalar kappa = 0.41;    // (von-Karmen's constant)
        const scalar lambdaMax = 250; // (maximum length scale)
    
        // Get the database
        const IOdictionary& d = static_cast<const IOdictionary&>(dict);
        
        // Get the mesh and create a height field
        const fvMesh& mesh = refCast<const fvMesh>(d.db());
        scalarField z = mesh.C().component(2);

        // Get the TKE
        const volScalarField& k = d.db().lookupObject<volScalarField>("k");
    
        scalarField length = 1/(1/(kappa*z) + 1/lambdaMax);

        os  << pow(k,1.5)/length;
//}}} end code
    }
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

