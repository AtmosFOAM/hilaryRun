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
#line 24 "/home/hilary/OpenFOAM/hilary-7/run/hilary/boundaryLayer/Leipzig/stratifiedRealizableKE/0/dbdz.#codeStream"
#include "fvCFD.H"
        #include "singlePhaseTransportModel.H"
        #include "turbulentTransportModel.H"
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
    void codeStream_6d3d67b3931e24459d942f70d373799a8d913417
    (
        Ostream& os,
        const dictionary& dict
    )
    {
//{{{ begin code
        #line 48 "/home/hilary/OpenFOAM/hilary-7/run/hilary/boundaryLayer/Leipzig/stratifiedRealizableKE/0/dbdz.#codeStream"
const IOdictionary& d = static_cast<const IOdictionary&>(dict);
        const fvMesh& mesh = refCast<const fvMesh>(d.db());

        // Set constants specific to the buoyancy profile
        const scalar g = 9.81;
        const scalar Theta0 = 288;
        const scalar ustar = 0.65;
        const scalar L  = 580;
        const scalar beta = 4.7;
        
        // Look up coefficients set elsewhere
        const incompressible::turbulenceModel& turbulece
             = d.db().lookupObject<const incompressible::turbulenceModel>();

        scalarField dbdz(mesh.nCells(), scalar(0));
        os << dbdz;
//}}} end code
    }
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

} // End namespace Foam

// ************************************************************************* //

