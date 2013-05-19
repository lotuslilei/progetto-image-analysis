#include "Segment.h"

#include <cmath>

float Segment::segmentLength() const
{
	return std::sqrt(std::pow((float)(x1-x2), 2) + std::pow((float)(y1-y2), 2));
}

Segment::Segment() :
	x1(0), x2(0), y1(0), y2(0), id(0), valid(true)
{
}

Segment::Segment(int x1, int y1, int x2, int y2) :
	x1(x1), x2(x2), y1(y1), y2(y2), id(0), valid(true)
{
}

bool Segment::operator== (const Segment& b) const
{
	if(!this->valid && !b.valid) {
		return true;
	} else if(this->valid && b.valid) {
		if(	this->x1 == b.x1 &&
			this->y1 == b.y1 &&
			this->x2 == b.x2 &&
			this->y2 == b.y2) {
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}

bool Segment::operator< (const Segment& b) const
{
	return this->segmentLength() < b.segmentLength();
}

Segment Segment::getInvalidLine()
{
	Segment inv(0,0,0,0);
	inv.setValid(false);

	return inv;
}

CandidateSegments::CandidateSegments(Segment l1, Segment l2) :
	l1(l1), l2(l2)
{
}
